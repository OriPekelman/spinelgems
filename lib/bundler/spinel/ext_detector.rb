require "json"

module Bundler
  module Spinel
    # Auto-detect a gem's Spinel C-extensions from the `ffi_cflags
    # "@PLACEHOLDER@"` declarations *already* in its Ruby source — and emit a
    # draft `spinel-ext.json`. This keeps the convention strictly consumer-side:
    # a gem author doesn't have to know about (or ship) `spinel-ext.json`;
    # spinelgems infers what it needs from the existing `ffi_cflags` markers and
    # any sibling `.c` files. The supplier can adopt the manifest natively later
    # if they want — it's a faster, more explicit path, not a precondition.
    #
    # Matching heuristic: `@<PREFIX>_<NAME>_O@` → `.o` placeholder; look for a
    # `*<name>*.c` near the declaring `.rb`. `@<PREFIX>_<NAME>_CFLAGS@` → a
    # system-libs placeholder (no source); the maintainer or proxy still has to
    # supply `pkg_config` and `disabled_cflags`, but the placeholder + name are
    # detected. Whatever the detector can't infer it leaves blank and warns —
    # the output is a *draft* meant to be reviewed.
    class ExtDetector
      # Legacy form: ffi_cflags "@PLACEHOLDER@" → substitution at vendor time.
      FFI_CFLAGS = /ffi_cflags\s+["'](@[A-Z0-9_]+@)["']/.freeze
      # Post-matz/spinel#1011 form: ffi_cflags File.expand_path("name.o", __dir__).
      # Spinel const-folds the path from source position, so no substitution is
      # needed — vendor just has to compile the .c and place the .o where the
      # const-fold will look (next to the placed .rb).
      FFI_CFLAGS_EXPAND = /ffi_cflags\s+File\.expand_path\(\s*["']([^"']+\.o)["']\s*,\s*__dir__\s*\)/.freeze

      def initialize(dir, warn_io: $stderr)
        @dir = File.expand_path(dir)
        @warn = warn_io
      end

      # array of entries shaped like spinel-ext.json.
      # Legacy form (placeholder): dedup'd by placeholder; vendor substitutes.
      # Const-fold form (post-#1011): dedup'd by source path; vendor compiles +
      # places the .o, no substitution.
      def detect
        decls = scan_declarations
        return [] if decls.empty?

        seen = {}
        decls.each_with_object([]) do |d, acc|
          key = d[:kind] == :placeholder ? d[:value] : :"src:#{c_for(d)}"
          next if seen[key]

          seen[key] = true
          entry = d[:kind] == :placeholder ? build_placeholder_entry(d) : build_expand_entry(d)
          acc << entry if entry
        end
      end

      def to_json = JSON.pretty_generate(detect)

      private

      # [{ rb_file:, kind:, value: }, …]  kind ∈ {:placeholder, :expand}
      def scan_declarations
        Dir[File.join(@dir, "lib", "**", "*.rb")].each_with_object([]) do |f, acc|
          body = File.read(f)
          body.scan(FFI_CFLAGS)        { |m| acc << { rb_file: f, kind: :placeholder, value: m[0] } }
          body.scan(FFI_CFLAGS_EXPAND) { |m| acc << { rb_file: f, kind: :expand,      value: m[0] } }
        end
      end

      # .c file next to the .rb that's referenced via `File.expand_path("X.o", __dir__)`.
      def c_for(d)
        File.join(File.dirname(d[:rb_file]), d[:value].sub(/\.o\z/, ".c"))
      end

      def build_expand_entry(d)
        c_abs = c_for(d)
        name = File.basename(d[:value], ".o")
        unless File.exist?(c_abs)
          @warn.puts "[detect-ext] ffi_cflags File.expand_path(#{d[:value]}, __dir__): no matching .c at #{c_abs.sub(@dir + '/', '')}"
          return { "name" => name, "form" => "const-fold" }
        end
        { "name" => name, "form" => "const-fold",
          "source" => c_abs.sub(@dir + "/", ""), "cflags" => ["-O2"] }
      end

      # @TEP_SPHTTP_O@ → ["sphttp", :obj]
      # @TEP_PG_CFLAGS@ → ["pg", :cflags]
      # @FOO_BAR@      → ["foo_bar", :unknown]
      def decompose(placeholder)
        parts = placeholder.gsub(/\A@|@\z/, "").split("_")
        kind = case parts.last
               when "O"      then :obj
               when "CFLAGS" then :cflags
               end
        return [parts.join("_").downcase, :unknown] unless kind && parts.size >= 2

        # Trailing _O/_CFLAGS dropped. If there's a leading prefix word (like
        # "TEP"), drop it too; else keep what we have (e.g. @SPHTTP_O@ → "sphttp").
        middle = parts.size == 2 ? parts[0..-2] : parts[1..-2]
        [middle.join("_").downcase, kind]
      end

      # Prefer a `.c` in the same lib subtree as the declaring `.rb`. Falls back
      # to any `.c` whose basename contains the tag (case-insensitive).
      def find_source(rb_file, tag)
        cands = Dir[File.join(@dir, "**", "*.c")].select { |f| File.basename(f).downcase.include?(tag) }
        return nil if cands.empty?

        same = cands.find { |c| c.start_with?(File.dirname(rb_file) + "/") }
        (same || cands.first).sub(@dir + "/", "")
      end

      def build_placeholder_entry(d)
        tag, kind = decompose(d[:value])
        case kind
        when :obj
          source = find_source(d[:rb_file], tag)
          @warn.puts "[detect-ext] #{d[:value]}: no matching .c source found" if source.nil?
          { "name" => tag, "placeholder" => d[:value], "cflags" => ["-O2"] }.tap { |e| e["source"] = source if source }
        when :cflags
          @warn.puts "[detect-ext] #{d[:value]}: system-libs placeholder — fill in pkg_config + disabled_cflags before use"
          { "name" => tag, "placeholder" => d[:value], "pkg_config" => nil, "pkg_config_fallback" => nil,
            "optional" => true, "disabled_cflags" => nil }
        else
          @warn.puts "[detect-ext] #{d[:value]}: unknown shape — review by hand"
          { "name" => tag, "placeholder" => d[:value] }
        end
      end
    end
  end
end

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
      FFI_CFLAGS = /ffi_cflags\s+["'](@[A-Z0-9_]+@)["']/.freeze

      def initialize(dir, warn_io: $stderr)
        @dir = File.expand_path(dir)
        @warn = warn_io
      end

      # array of entries shaped like spinel-ext.json. uniq'd by placeholder.
      def detect
        placeholders = scan_placeholders
        return [] if placeholders.empty?

        seen = {}
        placeholders.each_with_object([]) do |p, acc|
          next if seen[p[:placeholder]]

          seen[p[:placeholder]] = true
          acc << build_entry(p)
        end
      end

      def to_json = JSON.pretty_generate(detect)

      private

      # [{ rb_file:, placeholder: }, …]
      def scan_placeholders
        Dir[File.join(@dir, "lib", "**", "*.rb")].each_with_object([]) do |f, acc|
          File.read(f).scan(FFI_CFLAGS) { |m| acc << { rb_file: f, placeholder: m[0] } }
        end
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

      def build_entry(p)
        tag, kind = decompose(p[:placeholder])
        case kind
        when :obj
          source = find_source(p[:rb_file], tag)
          @warn.puts "[detect-ext] #{p[:placeholder]}: no matching .c source found" if source.nil?
          { "name" => tag, "placeholder" => p[:placeholder], "cflags" => ["-O2"] }.tap { |e| e["source"] = source if source }
        when :cflags
          @warn.puts "[detect-ext] #{p[:placeholder]}: system-libs placeholder — fill in pkg_config + disabled_cflags before use"
          { "name" => tag, "placeholder" => p[:placeholder], "pkg_config" => nil, "pkg_config_fallback" => nil,
            "optional" => true, "disabled_cflags" => nil }
        else
          @warn.puts "[detect-ext] #{p[:placeholder]}: unknown shape — review by hand"
          { "name" => tag, "placeholder" => p[:placeholder] }
        end
      end
    end
  end
end

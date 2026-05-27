require "bundler"
require "bundler/lockfile_parser"
require "fileutils"
require "open3"
require "json"

module Bundler
  module Spinel
    # "Make it work" — the plugin's primary job. Spinel has no load path
    # (plain `require "x"` resolves only against <spinel>/lib) and inlines
    # `require_relative`. So to actually *use* a resolved dependency in a Spinel
    # build, its source has to be placed somewhere Spinel will follow, with the
    # require wiring generated. This is the reusable form of what projects do by
    # hand today (e.g. Toy's build_tep_app.sh concatenation, Roundhouse
    # vendoring part of Tep).
    #
    # Given a Gemfile.lock, vendor each gem's `lib/` into `<into>/<name>/` and
    # emit `<into>/deps.rb` — a manifest of `require_relative`s in lock order. A
    # Spinel program then just does `require_relative "vendor/spinel/deps"`.
    #
    # Gating is layered on but advisory here: placement and compatibility are
    # different jobs. `vendor` warns on non-compatible gems (so the experience
    # is nicer) but still places them; `check` is the hard gate.
    class Vendorer
      def initialize(engine: Engine.new, ledger: Ledger.new)
        @engine = engine
        @ledger = ledger
        @fetcher = GemFetcher.new
      end

      def vendor(lockfile = "Gemfile.lock", into: "vendor/spinel", warn_incompatible: true,
                 ext_overrides: {}, ext_disable: [])
        parsed = Bundler::LockfileParser.new(File.read(lockfile))
        lock_dir = File.dirname(File.expand_path(lockfile))
        into = File.expand_path(into)
        FileUtils.mkdir_p(into)
        disable = (ext_disable + ENV["SPINEL_EXT_DISABLE"].to_s.split(",")).map(&:strip).reject(&:empty?)

        manifest = []
        exts = 0
        parsed.specs.each do |spec|
          name = spec.name
          version = spec.version.to_s
          src = resolve_source(spec, lock_dir)
          dest = File.join(into, name)
          place(src, dest)
          exts += wire_extensions(src, dest, ext_overrides, disable)
          manifest << require_target(name, dest)
          note_compat(name, version) if warn_incompatible
        end

        write_manifest(into, manifest)
        { into: into, count: manifest.size, extensions: exts }
      end

      # path:/git: lockfile sources (toy ↔ tep is the headline case)
      # point at a local tree; we don't go through `gem fetch`. For GEM
      # sources we fall back to the cache-backed RubyGems fetcher.
      # Issue: OriPekelman/spinelgems#3.
      def resolve_source(spec, lock_dir)
        src = spec.source
        if src.respond_to?(:path) && src.path
          path = src.path.to_s
          # Bundler stores PATH as relative-to-lockfile; resolve to abs.
          path = File.expand_path(path, lock_dir) unless File.absolute_path?(path)
          unless File.directory?(path)
            raise Error, "path: source for #{spec.name} not found: #{path}"
          end
          return path
        end
        @fetcher.fetch(spec.name, spec.version.to_s)
      end

      private

      def place(src, dest)
        FileUtils.rm_rf(dest)
        FileUtils.mkdir_p(dest)
        %w[lib].each do |sub|
          s = File.join(src, sub)
          FileUtils.cp_r(s, dest) if File.directory?(s)
        end
      end

      # Build + wire any C extensions the gem declares in spinel-ext.json
      # (OriPekelman/spinelgems#2; see docs/c-ext.md). Each entry substitutes its
      # @PLACEHOLDER@ in the placed Ruby — so the gem's `ffi_cflags "@PLACEHOLDER@"`
      # links it — with, in order:
      #   - the gem's own `.o` (category A): a prebuilt override, else compile the
      #     declared `source` .c;
      #   - system libs (category B): resolved from `pkg_config` at the *consumer's*
      #     environment (with `pkg_config_fallback`), not a hardcoded -l;
      #   - any static `libs`.
      # An `optional` entry the consumer opted out of (`name` in `disable` /
      # SPINEL_EXT_DISABLE) substitutes its `disabled_cflags` instead (category C).
      # Returns the count wired. A no-op for gems without the manifest.
      def wire_extensions(src, dest, overrides, disable)
        manifest = File.join(src, "spinel-ext.json")
        return 0 unless File.exist?(manifest)

        wired = 0
        JSON.parse(File.read(manifest)).each do |e|
          placeholder = e["placeholder"]
          next unless placeholder

          if e["optional"] && disable.include?(e["name"].to_s)
            substitute_placeholder(dest, placeholder, e["disabled_cflags"].to_s)
            wired += 1
            next
          end

          parts = []
          if (obj = overrides[placeholder] || ENV[ext_env_key(placeholder)])
            parts << obj
          elsif e["source"]
            built = compile_ext(src, dest, e) or next # compile failed: leave placeholder
            parts << built
          end
          if e["pkg_config"]
            pc = pkg_config_flags(e) or next # required pkg-config missing: leave placeholder
            parts << pc
          end
          parts.concat(Array(e["libs"]))

          substitute_placeholder(dest, placeholder, parts.join(" ").strip)
          wired += 1
        end
        wired
      rescue JSON::ParserError => e
        warn "[vendor] #{File.basename(dest)}: ignoring bad spinel-ext.json (#{e.message})"
        0
      end

      # System libs/cflags for an entry, resolved at the consumer's environment:
      # `pkg-config --cflags --libs <name>`, else `pkg_config_fallback`, else nil
      # (leave the placeholder so the build fails loud — we never silently drop a
      # required system dependency).
      def pkg_config_flags(entry)
        out, st = Open3.capture2e("pkg-config", "--cflags", "--libs", entry["pkg_config"].to_s)
        return out.strip if st.success?

        fallback = entry["pkg_config_fallback"].to_s
        return fallback unless fallback.empty?

        warn "[vendor] pkg-config #{entry['pkg_config']} failed, no fallback — " \
             "#{entry['placeholder']} left unresolved (build will fail loud)"
        nil
      end

      # `cc <cflags> -c <gem>/<source> -o <dest>/<base>.o`. The .o is a
      # host-specific build artifact, placed alongside the vendored Ruby.
      def compile_ext(src, dest, entry)
        source = File.join(src, entry["source"].to_s)
        unless File.exist?(source)
          warn "[vendor] ext source not found for #{entry['placeholder']}: #{entry['source']}"
          return nil
        end

        obj = File.join(dest, "#{File.basename(entry['source'], '.*')}.o")
        cmd = [ENV.fetch("CC", "cc"), *Array(entry["cflags"]), "-c", source, "-o", obj]
        out, st = Open3.capture2e(*cmd)
        return obj if st.success?

        warn "[vendor] ext compile failed (#{entry['placeholder']}): #{out.lines.last(2).join.strip}"
        nil
      end

      def substitute_placeholder(dest, placeholder, repl)
        Dir[File.join(dest, "**", "*.rb")].each do |f|
          body = File.read(f)
          File.write(f, body.gsub(placeholder, repl)) if body.include?(placeholder)
        end
      end

      # @TEP_SPHTTP_O@ -> SPINEL_EXT_TEP_SPHTTP_O
      def ext_env_key(placeholder)
        "SPINEL_EXT_" + placeholder.gsub(/[^A-Za-z0-9]+/, "_").gsub(/\A_|_\z/, "")
      end

      # The relative path a Spinel program require_relatives. Spinel inlines it
      # and follows the gem's own require_relatives from there.
      def require_target(name, dest)
        base = File.basename(dest)
        main = File.join(dest, "lib", "#{name}.rb")
        if File.exist?(main)
          "#{base}/lib/#{name}"
        else
          first = Dir[File.join(dest, "lib", "*.rb")].sort.first
          first ? "#{base}/lib/#{File.basename(first, '.rb')}" : nil
        end
      end

      def note_compat(name, version)
        v = @ledger.lookup(name, version, @engine.rev)
        return if v&.clean? || v&.verified?

        label = v ? v.verdict : "unprobed"
        warn "[vendor] #{name} #{version}: #{label} for #{@engine.rev} " \
             "— may not compile (run `spinel-compat check`)"
      end

      def write_manifest(into, targets)
        body = +"# Generated by bundler-spinel. require_relative this from a\n" \
                "# Spinel program to pull in vendored dependencies (lock order).\n"
        targets.compact.each { |t| body << %{require_relative "#{t}"\n} }
        File.write(File.join(into, "deps.rb"), body)
      end
    end
  end
end

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

        entries = JSON.parse(File.read(manifest))

        # A module's C extension can be split across two manifest entries: a
        # `source` `.o` entry (@MOD_O@) and a CFLAGS-only sibling (@MOD_CFLAGS@)
        # carrying the `pkg_config` include path. They share `name` (the detector
        # decomposes both `@TEP_PG_O@` and `@TEP_PG_CFLAGS@` to name "pg"). The
        # source compile must see the sibling's include path, or e.g. tep's
        # `tep_pg.c` can't find <libpq-fe.h> (spinelgems#8). Pre-resolve the
        # compile-time cflags each module name contributes from its CFLAGS-only
        # siblings so compile_ext gets them.
        sib_cflags = Hash.new { |h, k| h[k] = [] }
        entries.each do |e|
          next if e["source"] || !e["name"]              # only CFLAGS-only siblings
          next if e["optional"] && disable.include?(e["name"].to_s)
          (cf = pkg_config_cflags(e)) && sib_cflags[e["name"].to_s].concat(cf)
          sib_cflags[e["name"].to_s].concat(Array(e["cflags"])) if e["cflags"]
        end

        wired = 0
        entries.each do |e|
          placeholder = e["placeholder"]
          name = e["name"]

          # Opt-out (only meaningful with a placeholder to write disabled_cflags into).
          if e["optional"] && name && disable.include?(name.to_s)
            substitute_placeholder(dest, placeholder, e["disabled_cflags"].to_s) if placeholder
            wired += 1
            next
          end

          # Build-unit entry (spinelgems#14): a declared native build (cmake|make)
          # producing archives *inside the consumer's vendor tree*, with `link`
          # flags expanded relative to it ({dir} -> the vendored build dir). This
          # is the heavy-native analogue of `source` per-.c entries — nokogiri's
          # mini_portile2 precedent, Spinel-shaped. It replaces the per-consumer
          # post-vendor absolute-path rewrite hooks (toy's prep/post_vendor_toy.rb)
          # that made vendored trees non-relocatable and toy unpublishable.
          # A consumer override (SPINEL_EXT_<PLACEHOLDER> / --ext) supplies the
          # full replacement flags and skips the build (prebuilt escape hatch).
          if e["build"]
            if placeholder && (ov = overrides[placeholder] || ENV[ext_env_key(placeholder)])
              substitute_placeholder(dest, placeholder, ov.to_s)
              wired += 1
              next
            end
            ven_dir = build_unit(src, dest, e) or next # build failed (warned)
            if placeholder
              parts = Array(e["link"]).map { |t| t.gsub("{dir}", ven_dir) }
              parts.concat(Array(e["libs"]))
              substitute_placeholder(dest, placeholder, parts.join(" ").strip)
            end
            wired += 1
            next
          end

          # Compile / place the .o (or take a prebuilt override path). Both forms
          # need this; post-#1011 const-fold form skips the substitution below.
          obj = nil
          if placeholder && (ov = overrides[placeholder] || ENV[ext_env_key(placeholder)])
            obj = ov
          elsif e["source"]
            obj = compile_ext(src, dest, e, sib_cflags[name.to_s]) or next # compile failed
          end

          # Legacy placeholder form: substitute @PLACEHOLDER@ with <.o> <pkg-cfg> <libs>.
          if placeholder
            parts = []
            parts << obj if obj
            if e["pkg_config"]
              pc = pkg_config_flags(e) or next
              parts << pc
            end
            parts.concat(Array(e["libs"]))
            substitute_placeholder(dest, placeholder, parts.join(" ").strip)
          end
          # Const-fold form (e["form"] == "const-fold" / no placeholder): the .o
          # is already placed by compile_ext at the path the source-position
          # `File.expand_path` will resolve to. No text rewriting needed.

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

      # Just the compile-time include flags (`pkg-config --cflags <pkg>`), split
      # into argv tokens, for folding a CFLAGS-only sibling entry into a source
      # entry's compile (spinelgems#8). The `--libs` side is a link flag and is
      # added at the placeholder substitution, not here. nil if unavailable —
      # the compile then fails loud, which is correct (a required include path).
      def pkg_config_cflags(entry)
        return nil unless entry["pkg_config"]
        out, st = Open3.capture2e("pkg-config", "--cflags", entry["pkg_config"].to_s)
        st.success? && !out.strip.empty? ? out.strip.split : nil
      end

      # `cc <cflags> -c <gem>/<source> -o <dest>/<base>.o`. The .o is a
      # host-specific build artifact, placed alongside the vendored Ruby.
      def compile_ext(src, dest, entry, extra_cflags = [])
        source_rel = entry["source"].to_s
        source_abs = File.join(src, source_rel)
        unless File.exist?(source_abs)
          warn "[vendor] ext source not found for #{entry['placeholder'] || entry['name']}: #{source_rel}"
          return nil
        end

        # Place the .o at the source's relative path under dest — both legacy
        # (the absolute path goes into the placeholder substitution) and
        # const-fold (Spinel resolves `File.expand_path("X.o", __dir__)` to
        # this same location) consume that placement.
        obj_rel = source_rel.sub(/\.[^.]*\z/, ".o")
        obj = File.join(dest, obj_rel)
        FileUtils.mkdir_p(File.dirname(obj))
        # extra_cflags: include paths from a CFLAGS-only sibling entry for the
        # same module (spinelgems#8 — e.g. @TEP_PG_CFLAGS@'s `pkg-config libpq`).
        cmd = [ENV.fetch("CC", "cc"), *Array(entry["cflags"]), *Array(extra_cflags), "-c", source_abs, "-o", obj]
        out, st = Open3.capture2e(*cmd)
        return obj if st.success?

        warn "[vendor] ext compile failed (#{entry['placeholder'] || entry['name']}): #{out.lines.last(2).join.strip}"
        nil
      end

      # Build-unit (spinelgems#14): copy the gem's declared build dir into the
      # vendor tree, run the declared tool there, verify the declared artifacts.
      # Returns the vendored dir path (project-relative when `into` was given
      # relative — the usual case — so substituted -L flags stay relocatable
      # with the consumer project) or nil on failure (warned, entry skipped).
      #
      # The tool surface is deliberately constrained to cmake|make with declared
      # args/targets/artifacts — no free-form shell. extconf.rb is precedent for
      # arbitrary install-time code in gems, but there's no need to copy that
      # mistake into spinel-ext.json: a declarative unit stays auditable and the
      # detector-inferable, consumer-side philosophy survives.
      def build_unit(src, dest, entry)
        b = entry["build"]
        dir_rel = b["dir"].to_s
        src_dir = File.join(src, dir_rel)
        unless File.directory?(src_dir)
          warn "[vendor] build dir not found for #{entry['name'] || entry['placeholder']}: #{dir_rel}"
          return nil
        end

        ven_dir = File.join(dest, dir_rel)
        FileUtils.mkdir_p(File.dirname(ven_dir))
        FileUtils.rm_rf(ven_dir)
        FileUtils.cp_r(src_dir, ven_dir)

        # Declared patches (toy#45: pristine vendored ggml + vendor-patches/*.patch),
        # applied into the COPY before configure — mini_portile's patch_files
        # precedent. Globs resolve against the gem root; patch files are data,
        # which keeps the no-free-form-shell property of the schema.
        patches = Array(entry["build"]["patches"]).flat_map { |g| Dir[File.join(src, g.to_s)].sort }
        patches.each do |p|
          out, st = Open3.capture2e("patch", "-p1", "-d", ven_dir, "-i", File.expand_path(p))
          unless st.success?
            warn "[vendor] patch failed (#{entry['name']}): #{File.basename(p)}: #{out.lines.last(2).join.strip}"
            return nil
          end
        end

        jobs = begin
          require "etc"
          Etc.nprocessors.to_s
        rescue StandardError
          "4"
        end
        cmds =
          case b["tool"].to_s
          when "cmake"
            build_dir = File.join(ven_dir, "build")
            cfg = ["cmake", "-S", ven_dir, "-B", build_dir, *Array(b["args"]).map(&:to_s)]
            bld = ["cmake", "--build", build_dir, "-j", jobs]
            targets = Array(b["targets"]).map(&:to_s)
            bld.push("--target", *targets) unless targets.empty?
            [cfg, bld]
          when "make"
            [["make", "-C", ven_dir, "-j", jobs,
              *Array(b["args"]).map(&:to_s), *Array(b["targets"]).map(&:to_s)]]
          else
            warn "[vendor] unknown build tool #{b['tool'].inspect} for #{entry['name']} (cmake|make)"
            return nil
          end

        cmds.each do |cmd|
          out, st = Open3.capture2e(*cmd)
          unless st.success?
            warn "[vendor] build failed (#{entry['name']}): #{cmd.take(2).join(' ')} ... : " \
                 "#{out.lines.last(3).join.strip}"
            return nil
          end
        end

        missing = Array(b["artifacts"]).reject { |a| File.exist?(File.join(ven_dir, a.to_s)) }
        unless missing.empty?
          warn "[vendor] build for #{entry['name']} succeeded but artifacts missing: #{missing.join(', ')}"
          return nil
        end

        ven_dir
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

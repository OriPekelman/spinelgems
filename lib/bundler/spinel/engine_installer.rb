require "fileutils"
require "open3"

module Bundler
  module Spinel
    # Provisions the Spinel *compiler* itself, so onboarding a Spinel project
    # doesn't start with an out-of-band `git clone matz/spinel && make`
    # (spinelgems#9). Fetches matz/spinel at a pinned revision, builds it
    # (`make deps && make all` — C-only, no Rust), caches the result keyed by
    # revision under `~/.cache/spinel/<rev>/`, and points a `current` symlink at
    # it. `Engine` resolves that cache after `SPINEL_DIR` and before PATH, so a
    # provisioned engine is found with zero further configuration.
    #
    # Same recipe the survey path freezes per-rev and the Upsun build hook runs —
    # promoted here to a first-class user command.
    class EngineInstaller
      REPO = "https://github.com/matz/spinel.git"
      # Known-good default when no rev is given and no SPINEL_PIN file is present.
      # Overridable by arg, a ./SPINEL_PIN file, or the SPINEL_REV env var.
      DEFAULT_REV = "60070a6".freeze

      def self.cache_root
        File.expand_path(ENV["SPINEL_CACHE"] || "~/.cache/spinel")
      end

      def self.current_dir = File.join(cache_root, "current")

      def initialize(rev: nil, out: $stdout)
        @rev = rev
        @out = out
      end

      # Returns the path to the provisioned `spinel` binary.
      def install(force: false)
        check_toolchain!
        rev = resolve_rev
        dir = File.join(self.class.cache_root, rev)
        bin = File.join(dir, "spinel")

        if File.executable?(bin) && !force
          @out.puts "engine #{rev} already provisioned"
        else
          fetch_and_build(rev, dir)
          bin = File.join(dir, "spinel")
          raise Error, "build finished but #{bin} is missing" unless File.executable?(bin)
        end

        link_current(dir)
        smoke!(bin)
        report(rev, dir, bin)
        bin
      end

      private

      # Resolve the revision to a stable cache key:
      #   explicit arg / env  ›  ./SPINEL_PIN (first line)  ›  DEFAULT_REV
      # A bare SHA is used as-is; a ref name (master, a tag) is resolved to its
      # SHA via `git ls-remote` so the cache key is immutable.
      def resolve_rev
        ref = @rev || ENV["SPINEL_REV"] || pin_file_rev || DEFAULT_REV
        return ref if ref =~ /\A[0-9a-f]{7,40}\z/

        @out.puts "resolving spinel ref '#{ref}' ..."
        line = capture("git", "ls-remote", REPO, ref)
        sha = line.to_s.split(/\s+/).first
        raise Error, "could not resolve spinel ref '#{ref}' on #{REPO}" unless sha && !sha.empty?
        sha[0, 7]
      end

      def pin_file_rev
        f = File.join(Dir.pwd, "SPINEL_PIN")
        return nil unless File.exist?(f)
        rev = File.foreach(f).find { |l| l !~ /\A\s*#/ && !l.strip.empty? }&.strip&.split&.first
        rev unless rev.to_s.empty?
      end

      def fetch_and_build(rev, dir)
        FileUtils.rm_rf(dir)
        FileUtils.mkdir_p(File.dirname(dir))
        @out.puts "cloning matz/spinel -> #{dir} ..."
        run!("git", "clone", "--quiet", REPO, dir)
        run!("git", "-C", dir, "checkout", "--quiet", rev)
        @out.puts "building (make deps) ..."
        run!("make", "-C", dir, "deps")
        @out.puts "building (make all) ... (a few minutes, one time per rev)"
        run!("make", "-C", dir, "all")
      end

      def link_current(dir)
        cur = self.class.current_dir
        FileUtils.rm_f(cur) if File.symlink?(cur) || File.exist?(cur)
        FileUtils.mkdir_p(File.dirname(cur))
        File.symlink(dir, cur)
      rescue NotImplementedError, Errno::EEXIST
        # symlinks unsupported (e.g. some Windows) — skip; SPINEL_DIR still works.
      end

      # Compile a trivial program and run the produced binary — `spinel -e` only
      # reports the build artifact, so an actual compile+run is the real check.
      def smoke!(bin)
        require "tmpdir"
        Dir.mktmpdir do |d|
          src = File.join(d, "smoke.rb")
          out = File.join(d, "smoke.bin")
          File.write(src, "puts(21 + 21)\n")
          _, st = Open3.capture2e(bin, src, "-o", out)
          raise Error, "provisioned engine could not compile a trivial program" unless st.success? && File.executable?(out)
          res, st2 = Open3.capture2e(out)
          raise Error, "engine compiled but ran wrong: printed #{res.strip.inspect}, expected 42" unless st2.success? && res.strip == "42"
        end
      end

      def report(rev, dir, bin)
        @out.puts ""
        @out.puts "✓ Spinel engine #{rev} ready"
        @out.puts "  binary : #{bin}"
        @out.puts "  current: #{self.class.current_dir} -> #{dir}"
        @out.puts ""
        @out.puts "`spinel-compat` and tep will find it automatically. To pin it explicitly:"
        @out.puts "  export SPINEL_DIR=#{dir}"
        @out.puts "  export SPINEL=#{bin}        # tep reads $SPINEL"
      end

      def check_toolchain!
        missing = %w[git make].reject { |t| which(t) }
        missing << "a C compiler (cc/gcc)" unless which("cc") || which("gcc")
        return if missing.empty?
        raise Error, "install-engine needs #{missing.join(', ')} on PATH to build the " \
                     "Spinel compiler from source. Install a build toolchain and retry."
      end

      def run!(*cmd)
        out, st = Open3.capture2e(*cmd)
        raise Error, "#{cmd.first} failed: #{out.lines.last(4).join.strip}" unless st.success?
        out
      end

      def capture(*cmd)
        out, st = Open3.capture2e(*cmd)
        st.success? ? out : nil
      end

      def which(name)
        ENV["PATH"].to_s.split(File::PATH_SEPARATOR).each do |d|
          p = File.join(d, name)
          return p if File.executable?(p) && !File.directory?(p)
        end
        nil
      end
    end

    # Scaffolds a minimal Spinel project so onboarding is `bundle install &&
    # spinel-compat init && bin/build` (spinelgems#9, stretch). Writes a Gemfile
    # with the engine marker + a framework gem, a hello entrypoint, and a
    # bin/build that provisions the engine, vendors deps, and compiles.
    module Scaffold
      module_function

      def init(dir, out: $stdout, rev: nil)
        FileUtils.mkdir_p(dir)
        engine_rev = rev || EngineInstaller::DEFAULT_REV
        write(out, File.join(dir, "Gemfile"), gemfile)
        # The engine revision is a git SHA — NOT a valid `engine_version:` (bundler
        # parses that as a Gem version requirement and `bundle lock` errors on a
        # SHA). So the rev lives in a SPINEL_PIN file, which `install-engine`
        # reads; the Gemfile keeps a version-literal advisory marker.
        write(out, File.join(dir, "SPINEL_PIN"), "#{engine_rev}\n")
        write(out, File.join(dir, "app.rb"), app_rb)
        bin = File.join(dir, "bin", "build")
        FileUtils.mkdir_p(File.dirname(bin))
        write(out, bin, build_sh)
        File.chmod(0o755, bin)
        write(out, File.join(dir, ".gitignore"), gitignore)
        # Pin the *real* CRuby (the one running this, which has spinel-compat) so
        # version managers don't misread the Gemfile's `engine: "spinel"` marker.
        # mise/asdf parse that as `ruby@spinel-0.0.0`, fail to find it, and fall
        # back to a Ruby without bundler-spinel — `bin/build` then can't find
        # `spinel-compat`. A config-tier .tool-versions overrides that parse.
        write(out, File.join(dir, ".tool-versions"), "ruby #{RUBY_VERSION}\n")
        out.puts ""
        out.puts "Scaffolded a Spinel + Tep project in #{dir}/"
        out.puts "Next:"
        out.puts "  cd #{dir}" unless File.expand_path(dir) == Dir.pwd
        out.puts "  ./bin/build           # ensures tep, resolves + vendors deps, provisions Spinel, compiles"
        out.puts "  ./app -p 4567         # run the native binary"
        out.puts ""
        out.puts "(The `engine: spinel` Gemfile marker makes `bundle install` refuse to run"
        out.puts " under CRuby by design — bin/build uses `bundle lock` + `spinel-compat vendor`.)"
      end

      def write(out, path, body)
        if File.exist?(path)
          out.puts "  skip (exists): #{path}"
        else
          File.write(path, body)
          out.puts "  create: #{path}"
        end
      end

      def gemfile
        <<~RUBY
          source "https://rubygems.org"

          # Spinel is the engine: code here is compiled ahead-of-time to a native
          # binary, not run on CRuby. `engine_version` is advisory and must be a
          # version literal (bundler parses it as a Gem requirement); the actual
          # engine revision install-engine builds is pinned in ./SPINEL_PIN.
          ruby "3.3.0", engine: "spinel", engine_version: "0.0.0"

          # The web framework — Sinatra-style, compiles via Spinel. >= 0.11.1 builds
          # its C helpers on demand (needed for `gem install tep` without `make`).
          # (For an unreleased sibling instead: gem "tep", git: "https://github.com/OriPekelman/tep.git")
          gem "tep", ">= 0.11.1"
        RUBY
      end

      def app_rb
        <<~RUBY
          require "tep"

          get "/" do
            "hello from a Spinel-compiled Tep app\\n"
          end
        RUBY
      end

      def build_sh
        <<~SH
          #!/usr/bin/env bash
          # From a fresh checkout to a native binary. The Gemfile's `engine: spinel`
          # marker makes `bundle install` refuse to run under CRuby, so we resolve
          # with `bundle lock` and place deps with `spinel-compat vendor` instead.
          set -e
          command -v tep >/dev/null 2>&1 || gem install tep   # the tep build CLI (a compile-time tool)
          [ -f Gemfile.lock ] || bundle lock                  # resolve deps (NOT `bundle install`)
          spinel-compat install-engine                        # fetch+build the pinned engine (cached)
          export SPINEL="${SPINEL:-$HOME/.cache/spinel/current/spinel}"  # tell tep where the engine is
          spinel-compat vendor                                # place deps where Spinel follows them
          tep build app.rb -o app                             # compile -> ./app
          echo "built ./app — run it with: ./app -p 4567"
        SH
      end

      def gitignore
        <<~TXT
          /app
          /vendor
          *.o
          *.bin
        TXT
      end
    end
  end
end

require "open3"
require "digest"
require "rbconfig"

module Bundler
  module Spinel
    # Locates the Spinel compiler and derives a stable *revision* identity for it.
    #
    # Forward-compatibility hinges on this: every compatibility verdict in the
    # ledger is keyed on the engine revision, never on a gem name alone. Spinel
    # ships no version string (`spinel --version` just prints usage; `git
    # describe` returns a bare SHA with no tags), so we key on the git revision
    # of the Spinel checkout — falling back to a content hash of the binary when
    # it isn't a git checkout. Upgrade Spinel → new rev → no ledger entry → the
    # gem is re-probed automatically. A gem that is `rejected` today and works
    # after a Spinel feature lands flips to `clean` on the next probe, with no
    # manual blocklist to maintain.
    class Engine
      attr_reader :dir, :bin

      def initialize(dir: ENV.fetch("SPINEL_DIR", File.expand_path("~/spinel")))
        @dir = dir
        # Prefer a checkout at `dir` (gives a git rev); otherwise fall back to a
        # `spinel` on PATH (installed binary — rev becomes a binary hash). This
        # makes the default work for most setups without configuration.
        local = File.join(dir, "spinel")
        @bin = File.executable?(local) ? local : (which("spinel") || local)
      end

      def available?
        File.executable?(@bin)
      end

      def ensure!
        return if available?

        raise Error, "spinel compiler not found at #{@bin} " \
                     "(set SPINEL_DIR or pass --spinel-dir)"
      end

      # Short, human-facing engine id, platform-scoped:
      #   "git:0adca86/arm64-darwin"  or  "git:0adca86+dirty/aarch64-linux".
      # Platform matters because verdicts that depend on the C compile + runtime
      # (analyze-failed, miscompile, build-error, verified) are not portable
      # across targets — only `unresolved:X` (pure analysis) is. So the same
      # Spinel commit built on the Mac and on the gx10 are *distinct* ledger revs.
      def rev
        @rev ||= "#{compute_rev}/#{platform}"
      end

      def platform
        cpu = RbConfig::CONFIG["host_cpu"]
        os  = RbConfig::CONFIG["host_os"].sub(/\d.*\z/, "").sub(/darwin.*/, "darwin")
        "#{cpu}-#{os}"
      end

      # The label a Gemfile declares via `engine_version:`. Advisory only — the
      # ledger key is `rev`, not this. Recorded so `check` can warn when the
      # declared label and the actual binary drift apart.
      def declared_version
        @declared_version
      end

      attr_writer :declared_version

      private

      def compute_rev
        if File.directory?(File.join(@dir, ".git"))
          sha = capture("git", "-C", @dir, "rev-parse", "--short", "HEAD")
          if sha && !sha.empty?
            dirty = capture("git", "-C", @dir, "status", "--porcelain")
            return "git:#{sha}" + (dirty.to_s.strip.empty? ? "" : "+dirty")
          end
        end
        # Not a git checkout: hash the binary so distinct builds get distinct keys.
        return "missing" unless available?

        "bin:#{Digest::SHA256.file(@bin).hexdigest[0, 12]}"
      end

      def which(cmd)
        ENV.fetch("PATH", "").split(File::PATH_SEPARATOR)
           .map { |p| File.join(p, cmd) }
           .find { |f| File.executable?(f) && !File.directory?(f) }
      end

      def capture(*cmd)
        out, st = Open3.capture2e(*cmd)
        st.success? ? out.strip : nil
      rescue StandardError
        nil
      end
    end
  end
end

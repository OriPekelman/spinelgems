require "open3"
require "digest"

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

      def initialize(dir: ENV.fetch("SPINEL_DIR", File.expand_path("~/sites/spinel")))
        @dir = dir
        @bin = File.join(dir, "spinel")
      end

      def available?
        File.executable?(@bin)
      end

      def ensure!
        return if available?

        raise Error, "spinel compiler not found at #{@bin} " \
                     "(set SPINEL_DIR or pass --spinel-dir)"
      end

      # Short, human-facing engine id, e.g. "git:0adca86" or "git:0adca86+dirty".
      def rev
        @rev ||= compute_rev
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

      def capture(*cmd)
        out, st = Open3.capture2e(*cmd)
        st.success? ? out.strip : nil
      rescue StandardError
        nil
      end
    end
  end
end

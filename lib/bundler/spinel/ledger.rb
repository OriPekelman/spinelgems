require "json"
require "fileutils"
require "time"

module Bundler
  module Spinel
    # Append-only JSONL record of compatibility verdicts, one line per
    # `(gem, version, engine_rev)`. The single source of truth that the
    # lock-time gate, the curated-source whitelist, and the platform-variant
    # opt-in are all views over.
    #
    # Append-only because verdicts are facts-as-of-a-rev: we never mutate
    # history, we add a newer probe. `lookup` returns the most recent matching
    # line, so a re-probe naturally supersedes an older one.
    class Ledger
      Verdict = Struct.new(
        :gem, :version, :rev, :verdict, :reasons, :risks, :probe, :at,
        keyword_init: true
      ) do
        # Hard no: will not compile, or compiles to silent no-ops we detected.
        def rejected? = verdict == "rejected"
        # Compiles clean *and* no risky dynamic constructs found statically.
        def clean? = verdict == "clean"
        # Compiles clean but uses constructs Spinel degrades silently
        # (define_method/eval/…): allowed by default, fails under --strict.
        def risky? = verdict == "risky"
        # Compiles clean AND the gem's own tests pass through a Spinel-compiled
        # harness. The only verdict that earns a whitelist slot / platform badge.
        def verified? = verdict == "verified"

        def to_line = JSON.generate(to_h.transform_keys(&:to_s))
      end

      DEFAULT_PATH = File.expand_path("../../../ledger/compat.jsonl", __dir__)

      attr_reader :path

      def initialize(path: ENV.fetch("SPINEL_COMPAT_LEDGER", DEFAULT_PATH))
        @path = path
      end

      def record(verdict)
        FileUtils.mkdir_p(File.dirname(@path))
        File.open(@path, "a") { |f| f.puts(verdict.to_line) }
        verdict
      end

      # Most recent verdict for this exact triple, or nil.
      def lookup(gem, version, rev)
        result = nil
        each { |v| result = v if v.gem == gem && v.version == version && v.rev == rev }
        result
      end

      # Every distinct (gem, version) the ledger has ever seen — the candidate
      # set for a forward-compat re-probe sweep under a new rev.
      def known_gems
        seen = {}
        each { |v| seen[[v.gem, v.version]] = true }
        seen.keys
      end

      def each
        return enum_for(:each) unless block_given?
        return unless File.exist?(@path)

        File.foreach(@path) do |line|
          line = line.strip
          next if line.empty?

          h = JSON.parse(line)
          yield Verdict.new(
            gem: h["gem"], version: h["version"], rev: h["rev"],
            verdict: h["verdict"], reasons: h["reasons"] || [],
            risks: h["risks"] || [], probe: h["probe"], at: h["at"]
          )
        end
      end

      def build(gem:, version:, rev:, verdict:, reasons: [], risks: [], probe: "compile")
        Verdict.new(
          gem: gem, version: version, rev: rev, verdict: verdict,
          reasons: reasons, risks: risks, probe: probe,
          at: Time.now.utc.iso8601
        )
      end
    end
  end
end

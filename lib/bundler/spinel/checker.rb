require "bundler"
require "bundler/lockfile_parser"

module Bundler
  module Spinel
    # The resolution-time gate. Reads a Gemfile.lock, resolves a verdict for
    # every locked gem (from the ledger, or by probing on a cache miss), and
    # decides pass/fail. This is what turns Spinel's compile-time-or-never
    # failure into a `bundle lock`-time failure.
    class Checker
      Result = Struct.new(:verdict, :rejected, :risky, :probed, keyword_init: true)

      def initialize(engine: Engine.new, ledger: Ledger.new)
        @engine = engine
        @ledger = ledger
        @fetcher = GemFetcher.new
        @probe = Probe.new(@engine, @ledger)
      end

      # strict: treat `risky` as a failure too.
      def check(lockfile = "Gemfile.lock", strict: false)
        @engine.ensure!
        parsed = Bundler::LockfileParser.new(File.read(lockfile))
        rejected = []
        risky = []
        verdicts = []

        parsed.specs.each do |spec|
          # path:/git: sources (e.g. a sibling like tep) probe in place; the
          # GEM source fetches. We only have name+version here, so prototype
          # handles the rubygems case; path/git probing is a documented TODO.
          v = verdict_for(spec.name, spec.version.to_s)
          next unless v # skipped (unfetchable / TODO source)

          verdicts << v
          rejected << v if v.rejected?
          risky << v if v.risky?
        end

        ok = rejected.empty? && (!strict || risky.empty?)
        Result.new(verdict: ok, rejected: rejected, risky: risky, probed: verdicts)
      end

      private

      def verdict_for(name, version)
        cached = @ledger.lookup(name, version, @engine.rev)
        return cached if cached

        dir = @fetcher.fetch(name, version)
        @probe.probe(name, version, dir)
      rescue Error => e
        warn "[spinel-compat] skipped #{name} #{version}: #{e.message}"
        nil
      end
    end
  end
end

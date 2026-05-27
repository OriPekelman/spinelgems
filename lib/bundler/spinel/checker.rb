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
        lock_dir = File.dirname(File.expand_path(lockfile))
        rejected = []
        risky = []
        verdicts = []

        parsed.specs.each do |spec|
          v = verdict_for(spec, lock_dir)
          next unless v # skipped (unfetchable / TODO source)

          verdicts << v
          rejected << v if v.rejected?
          risky << v if v.risky?
        end

        ok = rejected.empty? && (!strict || risky.empty?)
        Result.new(verdict: ok, rejected: rejected, risky: risky, probed: verdicts)
      end

      private

      # path:/git: sources probe in place (the local checkout); GEM
      # sources go through the cache-backed fetcher. Closes the TODO
      # noted in OriPekelman/spinelgems#3.
      def verdict_for(spec, lock_dir)
        name = spec.name
        version = spec.version.to_s
        cached = @ledger.lookup(name, version, @engine.rev)
        return cached if cached

        dir =
          if spec.source.respond_to?(:path) && spec.source.path
            path = spec.source.path.to_s
            path = File.expand_path(path, lock_dir) unless File.absolute_path?(path)
            File.directory?(path) or raise Error, "path: source for #{name} not found: #{path}"
            path
          else
            @fetcher.fetch(name, version)
          end
        @probe.probe(name, version, dir)
      rescue Error => e
        warn "[spinel-compat] skipped #{name} #{version}: #{e.message}"
        nil
      end
    end
  end
end

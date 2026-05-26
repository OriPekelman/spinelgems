require "open3"
require "set"

module Bundler
  module Spinel
    # Wholesale review: probe a large list of gems and aggregate the results.
    # The point isn't a pass/fail — it's the *histogram of rejection reasons*,
    # which directly prioritises what Spinel should support next (see RFC asks).
    #
    # Embarrassingly parallel: each gem is an independent fetch + compile, both
    # subprocess-bound (Open3 releases the GVL), so a thread pool scales across
    # cores. Verdicts are cached in the ledger, so a survey is resumable and
    # re-runnable; only ledger writes are serialised.
    class Survey
      def initialize(engine: Engine.new, ledger: Ledger.new, jobs: 4)
        @engine = engine
        @ledger = ledger
        @jobs = jobs
        @fetcher = GemFetcher.new
        @probe = Probe.new(@engine, @ledger)
        @mutex = Mutex.new
      end

      # names: Array<String>. Probes each at its latest version (ledger-cached).
      # Returns the Array<Ledger::Verdict> for the surveyed set.
      def run(names, progress: $stderr)
        @engine.ensure!
        queue = Queue.new
        names.each { |n| queue << n }
        results = []
        done = 0
        total = names.size

        workers = Array.new([@jobs, total].min) do
          Thread.new do
            until queue.empty?
              name = (queue.pop(true) rescue break)
              v = probe_one(name)
              @mutex.synchronize do
                results << v if v
                done += 1
                progress&.print("\r[survey] #{done}/#{total}  #{name.ljust(30)}")
              end
            end
          end
        end
        workers.each(&:join)
        progress&.puts("\r[survey] #{done}/#{total} done#{' ' * 30}")
        results.compact
      end

      # Aggregate a markdown report from ledger verdicts for `names` at this rev.
      #
      # Reads straight from the ledger — no network. The just-run probes already
      # recorded a verdict (with its resolved version) per surveyed gem at this
      # rev, so re-resolving each gem's latest version online would only repeat
      # work and serialise a 1k-name survey behind 1k `gem list -r` calls. We
      # take the *last* current-rev entry per gem: append-only means a re-probe
      # supersedes, and the survey probes a gem at one (latest) version per run.
      def report(names)
        wanted = names.to_set
        rev = @engine.rev
        latest = {}
        @ledger.each do |v|
          latest[v.gem] = v if v.rev == rev && wanted.include?(v.gem)
        end
        verdicts = latest.values
        counts = Hash.new(0)
        reasons = Hash.new(0)
        verdicts.each do |v|
          counts[v.verdict] += 1
          (v.reasons + v.risks).each { |r| reasons[normalize(r)] += 1 }
        end
        render(verdicts.size, counts, reasons)
      end

      private

      def probe_one(name)
        version = latest_version(name) or return nil
        cached = @ledger.lookup(name, version, @engine.rev)
        return cached if cached

        dir = @fetcher.fetch(name, version)
        # Probe runs spinel (CPU-bound, GVL released) — this is the whole point
        # of the thread pool, so it must NOT hold @mutex. The only shared write
        # is the ledger append, which Ledger#record serialises internally.
        @probe.probe(name, version, dir)
      rescue StandardError => e
        @mutex.synchronize { warn "\n[survey] #{name}: #{e.message}" }
        nil
      end

      def latest_version(name)
        out, st = Open3.capture2e("gem", "list", "-r", "-e", name)
        return nil unless st.success?

        out[/#{Regexp.escape(name)} \(([^,)]+)/, 1]
      end

      # Collapse `unresolved:foo`/`risk:bar`/`needs:baz` into ranked buckets.
      def normalize(reason)
        reason
      end

      def render(n, counts, reasons)
        ok = (counts["clean"] + counts["verified"])
        lines = []
        lines << "# Spinel gem-compatibility survey"
        lines << ""
        lines << "- engine rev: `#{@engine.rev}`"
        lines << "- gems surveyed: **#{n}**"
        lines << "- compatible (clean+verified): **#{ok}** (#{pct(ok, n)})  ·  " \
                 "risky: #{counts['risky']}  ·  rejected: #{counts['rejected']}"
        lines << ""
        lines << "## Top blockers (what to teach Spinel next)"
        lines << ""
        lines << "| count | reason |"
        lines << "|---|---|"
        reasons.sort_by { |_, c| -c }.first(25).each { |r, c| lines << "| #{c} | `#{r}` |" }
        lines << ""
        lines.join("\n")
      end

      def pct(a, b)
        b.zero? ? "0%" : "#{(100.0 * a / b).round(1)}%"
      end
    end
  end
end

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
      # Metaprogramming / reflection constructs Spinel treats as out of scope.
      # Mirrors Probe::RISK_TOKENS' reason vocabulary: whether a construct shows
      # up as a static risk (`send`) or as an unresolved call (`unresolved:send`),
      # it's bucketed as metaprog and kept *out* of the candidate-call list — the
      # point of that list is calls Spinel could plausibly learn, not ones it
      # deliberately won't.
      METAPROG = %w[
        eval instance_eval class_eval define_method method_missing
        respond_to_missing const_missing send public_send objectspace
        tracepoint binding
      ].freeze

      # How many candidate calls to show inline in the report. The full ranked
      # list always goes to candidates.tsv; 0 shows the whole list inline too.
      REPORT_CALLS = Integer(ENV.fetch("SPINEL_REPORT_CALLS", "200"))

      def initialize(engine: Engine.new, ledger: Ledger.new, jobs: 4, refresh: false, skip_known: nil)
        @engine = engine
        @ledger = ledger
        @jobs = jobs
        @refresh = refresh
        # Resume fast-path: when a gem already has *any* verdict at this rev,
        # short-circuit `probe_one` so we skip the per-gem `latest_version`
        # (a `gem list -r` HTTPS roundtrip × ~190k = hours of pure waste on a
        # restart). Defaults to !refresh — refresh means re-probe everything,
        # which by definition wants the fresh latest_version too.
        @skip_known = skip_known.nil? ? !refresh : skip_known
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
        n, counts, reasons = aggregate(names)
        render(n, counts, reasons)
      end

      # The full ranked candidate-call list as TSV (`count\tcall`, header first) —
      # the long-tail companion to the report's top-N inline table. Written to
      # candidates.tsv so the whole roadmap signal survives, not just the head.
      def candidates_tsv(names)
        _, _, reasons = aggregate(names)
        rows = candidate_calls(reasons).map { |call, c| "#{c}\t#{call}" }
        (["count\tcall"] + rows).join("\n") + "\n"
      end

      private

      # One ledger pass → [distinct-gem count, verdict histogram, reason
      # histogram] at the current rev. A verdict dedups its own reasons, so a
      # reason's count is "how many gems hit it" (not raw occurrences).
      def aggregate(names)
        wanted = names.to_set
        rev = @engine.rev
        latest = {}
        @ledger.each { |v| latest[v.gem] = v if v.rev == rev && wanted.include?(v.gem) }
        counts = Hash.new(0)
        reasons = Hash.new(0)
        latest.each_value do |v|
          counts[v.verdict] += 1
          (v.reasons + v.risks).each { |r| reasons[r] += 1 }
        end
        [latest.size, counts, reasons]
      end

      # Ranked [call, count] of unresolved core/stdlib calls — the candidate
      # features. Metaprogramming and `require` are excluded (out of scope); the
      # `unresolved:` prefix is stripped. Count desc, then name asc.
      def candidate_calls(reasons)
        reasons.each_with_object(Hash.new(0)) do |(r, c), acc|
          acc[r.sub(/\Aunresolved:/, "")] += c if category(r) == "call"
        end.sort_by { |call, c| [-c, call] }
      end

      # Bucket a reason/risk for the roadmap histogram.
      #   loadpath   no load path: `unresolved:require` + every `needs:<lib>`
      #   metaprog   reflection Spinel won't support (Probe::RISK_TOKENS' vocab)
      #   robustness analyzer failed / timed out — a compiler-hardening signal
      #   cext       a C-extension gem, uncompilable
      #   call       an unresolved core/stdlib call — a candidate feature
      def category(reason)
        return "loadpath"   if reason.start_with?("needs:") || reason == "unresolved:require"
        return "robustness" if reason == "analyze-failed" || reason == "analyze-timeout"
        return "cext"       if reason == "c-extension"

        base = reason.sub(/\Aunresolved:/, "")
        METAPROG.include?(base) ? "metaprog" : "call"
      end

      def probe_one(name)
        # Resume fast-path: if we already have any verdict for this gem at
        # this rev, treat it as cached without re-resolving the latest version
        # (saves the ~190k `gem list -r` calls a no-op restart would otherwise
        # make). Verdict freshness is handled by `--refresh`, which both
        # disables this short-circuit and forces a re-probe below.
        return nil if @skip_known && known_set.include?(name)

        version = latest_version(name) or return nil
        unless @refresh
          cached = @ledger.lookup(name, version, @engine.rev)
          return cached if cached
        end

        dir = @fetcher.fetch(name, version)
        # Probe runs spinel (CPU-bound, GVL released) — this is the whole point
        # of the thread pool, so it must NOT hold @mutex. The only shared write
        # is the ledger append, which Ledger#record serialises internally.
        @probe.probe(name, version, dir)
      rescue StandardError => e
        @mutex.synchronize { warn "\n[survey] #{name}: #{e.message}" }
        nil
      end

      # Set of gem names already probed at the current engine rev. Built once
      # per Survey instance (a single ledger pass, ~27MB at 84k entries → ~30ms);
      # process-sharded runs each build their own copy, which is fine.
      def known_set
        @known_set ||= begin
          rev = @engine.rev
          set = Set.new
          @ledger.each { |v| set << v.gem if v.rev == rev }
          set
        end
      end

      def latest_version(name)
        out, st = Open3.capture2e("gem", "list", "-r", "-e", name)
        return nil unless st.success?

        # `gem list -r` groups platform variants in one version cell, e.g.
        # "nokogiri (1.19.3 ruby java aarch64-linux-gnu …)". Take just the version
        # number (first token) so `gem fetch -v` doesn't choke on the platform
        # words (BadRequirementError) and silently skip every native gem.
        cap = out[/#{Regexp.escape(name)} \(([^,)]+)/, 1]
        cap && cap.strip.split(/\s+/).first
      end

      def render(n, counts, reasons)
        ok = counts["clean"] + counts["verified"]
        cats = Hash.new(0)
        reasons.each { |r, c| cats[category(r)] += c }
        cands = candidate_calls(reasons)
        cand_occ = cands.sum { |_, c| c }
        limit = REPORT_CALLS.zero? ? cands.size : REPORT_CALLS
        shown = [limit, cands.size].min

        lines = []
        lines << "# Spinel gem-compatibility survey"
        lines << ""
        lines << "- engine rev: `#{@engine.rev}`"
        lines << "- gems surveyed: **#{n}**"
        lines << "- compatible (clean+verified): **#{ok}** (#{pct(ok, n)})  ·  " \
                 "risky: #{counts['risky']}  ·  rejected: #{counts['rejected']}"
        lines << ""
        lines << "## Candidate features — unresolved calls Spinel could learn"
        lines << ""
        lines << "_Core/stdlib method calls only; metaprogramming and `require` " \
                 "excluded as known out-of-scope. The top is the real signal; the " \
                 "long tail is mostly calls unresolved only because their defining " \
                 "`require` wasn't followed._"
        lines << ""
        lines << "| count | call |"
        lines << "|---|---|"
        cands.first(shown).each { |call, c| lines << "| #{c} | `#{call}` |" }
        lines << ""
        footer = "Showing #{shown} of **#{cands.size}** distinct candidate calls " \
                 "(#{cand_occ} occurrences)."
        footer += " Set `SPINEL_REPORT_CALLS=0` for the full list." if shown < cands.size
        lines << footer
        lines << ""
        lines << "## Blockers by category"
        lines << ""
        lines << "| occurrences | category |"
        lines << "|---|---|"
        lines << "| #{cats['call']} | candidate core/stdlib calls (above) |"
        lines << "| #{cats['metaprog']} | metaprogramming / reflection — out of scope |"
        lines << "| #{cats['loadpath']} | no load path: `require` + `needs:` — probe limitation |"
        lines << "| #{cats['robustness']} | analyzer failed / timed out — compiler hardening |"
        lines << "| #{cats['cext']} | C extensions — uncompilable |"
        lines << ""
        lines << "## All blockers (top 100)"
        lines << ""
        lines << "| count | reason | category |"
        lines << "|---|---|---|"
        reasons.sort_by { |r, c| [-c, r] }.first(100).each do |r, c|
          lines << "| #{c} | `#{r}` | #{category(r)} |"
        end
        lines.join("\n") + "\n"
      end

      def pct(a, b)
        b.zero? ? "0%" : "#{(100.0 * a / b).round(1)}%"
      end
    end
  end
end

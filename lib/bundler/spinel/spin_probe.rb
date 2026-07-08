require "json"

module Bundler
  module Spinel
    # Projects an internal compat record (as emitted by Probe/Verifier and stored
    # in the ledger / survey compat.jsonl) into the spin-index package-record
    # shape that rubys introduced in matz/spin-index PR #1 (redis) and #2 (pg):
    # a `packages/<name>.toml` with `[[release]]` and `[[probe]]` tables.
    #
    #   name = "redis"
    #   repo = "https://github.com/rubys/spinel-redis"
    #   [[release]]
    #   version = "0.1.0"
    #   ref     = "4c2ceaba…"          # commit whose tree carries spin.toml
    #   [[probe]]
    #   version = "0.1.0"
    #   spinel  = "6c8dfa95829b"       # the compiler git SHA
    #   result  = "pass"
    #   date    = "2026-07-07"
    #
    # This is a PURE projection — it does not mutate our internal schema, which
    # carries a richer 5-rank verdict ladder plus reasons/risks that the
    # spin-index shape has no slot for. It exists so a future
    # `catalog -> packages/*.toml` generator (spinelgems#6, blocked on
    # matz/spinel#1753) is a field-rename, not a redesign.
    #
    # Field map (internal -> spin-index [[probe]]):
    #   version -> version
    #   rev     -> spinel    the compiler git SHA; we strip `git:` + `/platform`.
    #                        rubys emits a 12-hex short SHA, ours is 8-hex — both
    #                        are `git rev-parse --short` of the same matz/spinel
    #                        tree at different -N, so they compare by prefix.
    #   verdict -> result    "pass" iff verified (the only tier that cleared the
    #                        differential harness, matching rubys' `spin test`
    #                        gate); every weaker tier -> "fail".
    #   at      -> date      ISO date (the `at` timestamp truncated to YYYY-MM-DD).
    #
    # Our proposed extension for the candidate/roadmap use-case (matz/spinel#1753
    # Open Point #2): a `tier` key carrying the full verdict, so an index entry
    # can distinguish "never ported / does not compile" from "compiles but no
    # test evidence" — the leading-indicator signal a bare pass/fail loses. Pass
    # `strict: true` to omit it and emit only the four blessed fields.
    module SpinProbe
      module_function

      # "git:42adf886/aarch64-linux" -> "42adf886". Returns nil for a binary-hash
      # rev ("bin:<hash>", no git provenance) or a blank rev — a probe record
      # without a compiler SHA is meaningless, so callers should drop it.
      def compiler_sha(rev)
        return nil if rev.nil? || rev.empty?
        return nil unless rev.start_with?("git:")
        rev.sub(/\Agit:/, "").split("/", 2).first
      end

      # ISO date from an `at` timestamp ("2026-07-06T11:37:48Z" -> "2026-07-06").
      def probe_date(at)
        return nil if at.nil? || at.to_s.empty?
        at.to_s[0, 10]
      end

      # One spin-index [[probe]] table (as a Hash with string keys, insertion
      # order = emission order) for an internal record. `rec` uses string keys
      # ("version"/"rev"/"verdict"/"at"), as stored in the ledger and compat.jsonl.
      # `date:` overrides the record's `at`-derived date (the bulk reprobe records
      # carry no `at`; the run date is supplied then). Returns nil when the rev has
      # no compiler SHA.
      def probe_record(rec, date: nil, strict: false)
        sha = compiler_sha(rec["rev"])
        return nil unless sha
        h = {
          "version" => rec["version"],
          "spinel"  => sha,
          "result"  => (rec["verdict"] == "verified" ? "pass" : "fail")
        }
        h["tier"] = rec["verdict"] unless strict
        d = date || probe_date(rec["at"])
        h["date"] = d if d
        h
      end

      # Render a full packages/<name>.toml. `releases` and `probes` are arrays of
      # Hashes (string keys); each becomes a `[[release]]` / `[[probe]]` table in
      # order. `repo` is optional — a candidate gem with no spinel-<name> repo yet
      # omits it (the roadmap case); a real ported package carries it.
      def render_toml(name:, repo: nil, releases: [], probes: [])
        lines = [%(name = #{quote(name)})]
        lines << %(repo = #{quote(repo)}) if repo
        releases.each do |r|
          lines << ""
          lines << "[[release]]"
          r.each { |k, v| lines << %(#{k} = #{toml_value(v)}) }
        end
        probes.each do |p|
          lines << ""
          lines << "[[probe]]"
          p.each { |k, v| lines << %(#{k} = #{toml_value(v)}) }
        end
        "#{lines.join("\n")}\n"
      end

      # Convenience: a package TOML for one internal record. Emits the [[probe]]
      # table always; the [[release]] table only when a `ref` (commit SHA in the
      # package repo) is known — i.e. once the gem is actually ported. Candidate
      # records (no repo, no ref) render name + [[probe]] only, which is the
      # roadmap seed shape we propose in matz/spinel#1753.
      def package_toml(rec, repo: nil, ref: nil, date: nil, strict: false)
        probe = probe_record(rec, date: date, strict: strict)
        releases = ref ? [{ "version" => rec["version"], "ref" => ref }] : []
        render_toml(name: rec["gem"], repo: repo, releases: releases,
                    probes: probe ? [probe] : [])
      end

      def quote(str)
        %("#{str.to_s.gsub("\\", "\\\\\\\\").gsub('"', '\"')}")
      end

      def toml_value(val)
        case val
        when Integer, Float then val.to_s
        when true, false then val.to_s
        else quote(val)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Bundler
  module Spinel
    # `spinel-compat why <gem>` — a legible "why doesn't this gem work (yet)?"
    # report (spinelgems#12). Turns a recorded (or freshly probed) Verdict into
    # plain English: the cause, a category (Spinel limitation vs fixable compiler
    # bug vs native C-ext vs metaprogramming vs dependency-blocked), the specific
    # evidence, and what it would take — including whether the verdict is
    # TERMINAL (won't improve without an upstream/compiler change) or FIXABLE.
    #
    # The data is already in the ledger (the rubric tag, the spinel warnings
    # distilled into `reasons`, the static `risks`); this assembles it instead
    # of making a user grep C output. Where deeper localization helps, it points
    # at `verify --explain` / spinel-dev's doctor rather than depending on them.
    class Why
      # rubric/risk/reason signal -> structured explanation. :terminal is
      #   :native    — won't work without a Spinel-native port (terminal here)
      #   :limitation— a Spinel feature gap (improves when the compiler grows it)
      #   :bug       — a fixable Spinel compiler bug (file/track upstream)
      #   :dep       — blocked by a dependency (improves when the dep does)
      #   :ok        — already usable; nothing to fix
      EXPLAIN = {
        "c-extension" => {
          category: "native (C extension)", terminal: :native,
          cause: "ships a C extension; Spinel is whole-program AOT and never dlopens a .so.",
          take: "port the extension to Spinel's ffi_cflags/ffi_func DSL (tep/SpinelKit pattern), " \
                "or consume a pure-Ruby alternative. The CRuby .so cannot be vendored.",
        },
        "needs-dep" => {
          category: "dependency / not self-contained", terminal: :dep,
          cause: "fails under CRuby in the harness too — it needs an external gem, TLS, or network the probe doesn't provide.",
          take: "vendor the missing dependency (must itself be Spinel-compatible) or smoke only the offline surface.",
        },
        "load-path" => {
          category: "Spinel limitation (load path)", terminal: :limitation,
          cause: %(Spinel ignored a plain `require "gem/part"` (it has no load path), so the gem's real classes never compiled.),
          take: "restructure the gem to require_relative its own files (Spinel inlines those), or wait on load-path support.",
        },
        "needs-stdlib" => {
          category: "Spinel limitation (stdlib surface)", terminal: :limitation,
          cause: "requires a standard-library feature Spinel doesn't ship.",
          take: "use a Spinel-safe shim for that surface (SpinelKit consolidates these: JSON/Logger/…), or wait on stdlib coverage.",
        },
        "codegen" => {
          category: "compiler bug (codegen)", terminal: :bug,
          cause: "ordinary Ruby produced a C compile error — a fixable Spinel codegen bug, not a limitation of your code.",
          take: "file/track a matz/spinel issue. `verify --explain` (or spinel-dev doctor) localizes it to a file:line; " \
                "the harness usually has a minimal reproducer already.",
        },
        "miscompile" => {
          category: "compiler bug (silent miscompile)", terminal: :bug,
          cause: "it compiles and runs, but the output diverges from CRuby — the most dangerous failure, silently wrong.",
          take: "file a matz/spinel issue with the diff below; `verify --explain --bisect` localizes it to a file:line + variable.",
        },
        "unsupported" => {
          category: "unsupported call (often metaprogramming)", terminal: :bug,
          cause: "Spinel could not resolve a call and silently emitted 0 — typically dynamic dispatch (send/define_method/extend).",
          take: "if it's a small codegen gap, file a matz/spinel issue; if it's deep metaprogramming, the surface is currently unsupported.",
        },
        "build-error" => {
          category: "build/run error", terminal: :bug,
          cause: "the Spinel build or run failed for a reason outside the other buckets.",
          take: "inspect the reasons below; `verify --explain` surfaces the raw compiler line.",
        },
        "smoke-error" => {
          category: "inconclusive (smoke broken under CRuby)", terminal: :dep,
          cause: "the behaviour smoke didn't run cleanly under plain CRuby, so no Spinel conclusion can be drawn.",
          take: "fix the smoke (a self-contained example of the gem's API), then re-verify.",
        },
        "analyze-oom" => {
          category: "compiler bug (analyzer OOM)", terminal: :bug,
          cause: "the Spinel analyzer exhausts memory on this gem (matz/spinel#1302); it's blacklisted from probing.",
          take: "terminal until matz/spinel#1302 lands; tracked there with reproducers.",
        },
        # Static pre-filter rejections (probe=static): a hard construct found by
        # source scan before any compile. Thread/Mutex compile now but misbehave
        # (matz/spinel#1360); TracePoint/ObjectSpace are out of the AOT model.
        "hard-construct" => {
          category: "Spinel limitation (runtime construct)", terminal: :limitation,
          cause: "uses a construct the static filter rejects before compiling (threads/mutexes/tracing).",
          take: "Thread/Mutex are single-thread-degradable (matz/spinel#1360); TracePoint/ObjectSpace/set_trace_func " \
                "are outside the closed-world AOT model. Often the gem works once that one construct is shimmed.",
        },
      }.freeze

      POSITIVE = {
        "verified" => "compiles, and a behaviour smoke runs identically under CRuby and a Spinel-compiled binary. " \
                      "Trustworthy — the only verdict that earns a curated-source slot.",
        "loaded"   => "compiles and loads identically to CRuby, but no behaviour smoke has exercised its logic at this rev — " \
                      "so a silent miscompile in that logic is still possible. Run `verify --smoke <file>` to lift it to verified.",
        "clean"    => "compiles clean and uses no dynamic constructs Spinel degrades — but it has only been compiled, not run. " \
                      "Run `verify` (require-only → loaded) or `verify --smoke` (behaviour → verified) to confirm it works.",
        "risky"    => "compiles, but the source uses dynamic constructs Spinel degrades silently — allowed by default, " \
                      "rejected under `check --strict`. Whether it actually works depends on whether those paths run; " \
                      "a behaviour smoke (`verify --smoke`) is the only way to know.",
      }.freeze

      USABLE = %w[verified loaded clean risky].freeze

      def initialize(out: $stdout)
        @out = out
      end

      # Render the report for a Verdict (from the ledger or a live probe).
      def report(v, source: "ledger")
        @out.puts
        @out.puts "spinel-compat why #{v.gem}  (#{v.version} @ #{v.rev || 'unknown rev'}, via #{source})"
        @out.puts

        glyph = { "verified" => "★", "loaded" => "○", "clean" => "✓", "risky" => "~", "rejected" => "✗" }[v.verdict] || "?"
        line "verdict", "#{glyph} #{v.verdict}"

        if USABLE.include?(v.verdict)
          positive(v, glyph)
        else
          negative(v)
        end
        @out.puts
        v
      end

      private

      def positive(v, _glyph)
        line "meaning", POSITIVE[v.verdict] if POSITIVE[v.verdict]
        # risky/clean can still carry dynamic-construct risks worth surfacing.
        dyn = dynamic_risks(v)
        line "watch", "uses #{dyn.join(', ')} — Spinel may degrade these silently; a behaviour smoke confirms real behaviour." unless dyn.empty?
        unmet = blocking_deps(v)
        line "deps", "depends on #{unmet.join(', ')} (declared `needs:`) — vendor those too." unless unmet.empty?
      end

      def negative(v)
        tag = rubric_tag(v) || static_tag(v)
        info = EXPLAIN[tag] || EXPLAIN["build-error"]

        line "category", info[:category]
        line "cause", info[:cause]

        detail = evidence(v, tag)
        line "detail", detail unless detail.empty?

        unmet = blocking_deps(v)
        line "blocked-by", "rejected/unmet dependencies: #{unmet.join(', ')}" unless unmet.empty?

        line "terminal?", terminal_line(info[:terminal])
        line "what it'd take", info[:take]
      end

      # A static-probe rejection has no rubric tag; its reason IS the signal.
      def static_tag(v)
        reasons = v.reasons + v.risks
        return "analyze-oom"    if reasons.any? { |r| r.include?("analyze-oom") }
        return "c-extension"    if reasons.include?("c-extension")
        return "hard-construct" if reasons.any? { |r| r.start_with?("hard:") }
        return "unsupported"    if reasons.any? { |r| r.start_with?("unresolved:") }
        return "codegen"        if reasons.any? { |r| r =~ /out\.c:\d+:\d+: *error:/ }
        return "needs-dep"      if reasons.any? && reasons.all? { |r| r.start_with?("needs:") }
        nil
      end

      # --- signal extraction ---------------------------------------------------

      def rubric_tag(v)
        v.reasons.grep(/\Arubric:/).first&.sub("rubric:", "")
      end


      DYNAMIC = %w[define_method instance_eval class_eval module_eval eval send method_missing
                   const_set define_singleton_method].freeze

      def dynamic_risks(v)
        v.risks.select { |r| DYNAMIC.include?(r) || DYNAMIC.any? { |d| r.include?(d) } }.uniq
      end

      def blocking_deps(v)
        (v.reasons + v.risks).grep(/\Aneeds:/).map { |r| r.sub("needs:", "") }.uniq
      end

      # The concrete evidence lines for a rejection, by tag.
      def evidence(v, tag)
        case tag
        when "miscompile"
          v.reasons.grep(/\Adiff:/).first.to_s.sub("diff:", "CRuby vs Spinel ").strip
        when "unsupported"
          calls = v.reasons.grep(/\Aunresolved:/).map { |r| r.sub("unresolved:", "") }
          calls.empty? ? "" : "unresolved: #{calls.first(8).join(', ')}#{calls.size > 8 ? " (+#{calls.size - 8} more)" : ''}"
        when "load-path", "needs-stdlib"
          miss = v.reasons.grep(/could not be resolved|no .+\.rb/).first
          miss ? miss.strip : ""
        when "codegen", "build-error"
          v.reasons.grep(/out\.c:|error:|fatal/i).first.to_s.strip
        when "hard-construct"
          v.reasons.grep(/\Ahard:/).map { |r| r.sub("hard:", "") }.join(", ")
        when "c-extension"
          "an ext/ directory with C/C++ sources (compiled by mkmf under CRuby)"
        else
          # fall back to the most informative non-rubric reason
          v.reasons.reject { |r| r.start_with?("rubric:") }.first.to_s.strip
        end
      end

      def terminal_line(kind)
        case kind
        when :native     then "TERMINAL here — needs a Spinel-native port, not a catalog/compiler change."
        when :limitation then "improves when Spinel grows the feature (a limitation, not a per-gem bug)."
        when :bug        then "FIXABLE — a compiler bug; the catalog tracks it and it can graduate on a Spinel fix."
        when :dep        then "conditional — unblocks when the dependency (or the smoke) is resolved."
        else "—"
        end
      end

      def line(label, text)
        @out.puts format("  %-14s %s", label, text)
      end
    end
  end
end

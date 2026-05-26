require "open3"
require "tmpdir"

module Bundler
  module Spinel
    # Decides a compatibility verdict for an unpacked gem against the current
    # Spinel engine. Two complementary signals, because Spinel's failure modes
    # are *not* exit codes:
    #
    #   1. COMPILE SIGNAL. Spinel never exits non-zero on unsupported Ruby; it
    #      emits `warning: ... cannot resolve call to 'X' ... (emitting 0)` and
    #      degrades the call to a no-op. So we compile the gem's lib entrypoints
    #      with `spinel -c` and parse stderr. An unresolved-call warning names
    #      the exact missing feature (`unresolved:eval`), which is what makes the
    #      verdict forward-compatible — re-probing under a newer engine clears it
    #      the moment Spinel learns that call.
    #
    #   2. STATIC RISK SIGNAL. Some constructs (define_method, instance_eval, a
    #      bare `send`) are degraded with *no* warning at all, and dead-code
    #      elimination can hide an unsupported call that's defined-but-uncalled
    #      in a library. So we also scan the source for known-risky tokens. These
    #      don't reject on their own (the gem may never hit that path) but they
    #      downgrade `clean` → `risky`.
    #
    # NEITHER signal catches Spinel's *silent miscompiles* (local-var-name
    # collapse, Int-0-as-nil). Only the `verified` rung — running the gem's own
    # tests through a Spinel-compiled harness — does. The lock-time gate trusts
    # `clean`; only a curated whitelist / platform variant trusts `verified`.
    class Probe
      # An unsupported *call* — the strongest, most precise signal, and the one
      # that's forward-compatible (names the exact feature Spinel lacks today).
      UNRESOLVED_CALL = /cannot resolve call to '([^']+)'/.freeze
      # A `require "x"` Spinel couldn't follow. Spinel has no load path (plain
      # require resolves only against <spinel>/lib), so a gem's own split files
      # and stdlib deps surface here. Informational, NOT a standalone reject:
      # it's as often a probe limitation as a real incompatibility.
      UNRESOLVED_REQUIRE = /require "([^"]+)" could not be resolved/.freeze
      ANALYZE_FAILED = /\b(analyze failed|fatal)\b/i.freeze

      # token => reason. Tokens Spinel cannot honour and may silently no-op.
      RISK_TOKENS = {
        /\beval\s*\(/                  => "eval",
        /\binstance_eval\b/            => "instance_eval",
        /\b(class|module)_eval\b/      => "class_eval",
        /\bdefine_method\b/            => "define_method",
        /\bmethod_missing\b/           => "method_missing",
        /\brespond_to_missing\?/       => "respond_to_missing",
        /\bconst_missing\b/            => "const_missing",
        /\.send\s*\(/                  => "send",
        /\bpublic_send\b/              => "public_send",
        /\bObjectSpace\b/              => "objectspace",
        /\b(TracePoint|set_trace_func)\b/ => "tracepoint",
        /\bbinding\b/                  => "binding"
      }.freeze

      def initialize(engine, ledger)
        @engine = engine
        @ledger = ledger
      end

      # gem_name, version, dir(unpacked) -> recorded Ledger::Verdict
      def probe(gem_name, version, dir)
        @engine.ensure!
        sig = compile_signal(dir, gem_name)
        risks = static_signal(dir)
        # Unfollowed requires are notes, not rejections — record them so a human
        # can see when a verdict is entangled with the no-load-path limitation.
        risks += sig[:requires].map { |r| "needs:#{r}" }

        verdict, reasons =
          if !sig[:calls].empty?
            # Genuine unsupported call(s): unambiguous, forward-compatible reject.
            ["rejected", sig[:calls].map { |s| "unresolved:#{s}" }]
          elsif sig[:analyze_failed] || !sig[:exit_ok]
            ["rejected", ["analyze-failed"]]
          elsif !static_only_risks(risks).empty?
            ["risky", []]
          else
            ["clean", []]
          end

        @ledger.record(@ledger.build(
          gem: gem_name, version: version, rev: @engine.rev,
          verdict: verdict, reasons: reasons.uniq, risks: risks.uniq, probe: "compile+scan"
        ))
      end

      private

      # Compile the gem's lib entrypoints as a Spinel program; classify stderr.
      def compile_signal(dir, gem_name)
        entries = entrypoints(dir, gem_name)
        return { calls: [], requires: [], analyze_failed: true, exit_ok: false } if entries.empty?

        calls = []
        requires = []
        analyze_failed = false
        exit_ok = true
        Dir.mktmpdir do |tmp|
          entries.each do |f|
            out, st = Open3.capture2e(@engine.bin, "-c", f, "-o", File.join(tmp, "out.c"))
            exit_ok &&= st.success?
            analyze_failed ||= out =~ ANALYZE_FAILED ? true : false
            out.scan(UNRESOLVED_CALL) { |m| calls << m[0] }
            out.scan(UNRESOLVED_REQUIRE) { |m| requires << m[0] }
          end
        end
        { calls: calls.uniq, requires: requires.uniq,
          analyze_failed: analyze_failed, exit_ok: exit_ok }
      end

      # Risks from the static source scan (exclude the `needs:` require notes).
      def static_only_risks(risks)
        risks.reject { |r| r.start_with?("needs:") }
      end

      # The gem's conventional require targets: lib/<name>.rb, else top-level
      # lib/*.rb. Spinel inlines their require_relatives, so compiling the entry
      # pulls in the whole tree.
      def entrypoints(dir, gem_name)
        lib = File.join(dir, "lib")
        return [] unless File.directory?(lib)

        main = File.join(lib, "#{gem_name}.rb")
        return [main] if File.exist?(main)

        Dir[File.join(lib, "*.rb")]
      end

      def static_signal(dir)
        risks = []
        # C-extension gems can't be compiled by Spinel at all.
        risks << "c-extension" if Dir[File.join(dir, "ext", "**", "*.{c,cpp,cc,h}")].any?

        Dir[File.join(dir, "lib", "**", "*.rb")].each do |f|
          src = File.read(f)
          RISK_TOKENS.each { |re, reason| risks << reason if src =~ re }
        end
        risks.uniq
      end
    end
  end
end

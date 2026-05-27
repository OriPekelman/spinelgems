require "open3"

module Bundler
  module Spinel
    # The `verified` rung: differential testing. Runs a smoke program that
    # exercises the gem once under CRuby and once compiled by Spinel, and
    # compares stdout. This is the *only* signal that catches Spinel's silent
    # miscompiles (local-var-name collapse, Int-0-as-nil) — they emit no warning
    # and exit 0, so the cheap probe can't see them, but a differential run does:
    # CRuby and the miscompiled binary diverge.
    #
    #   match, behaviour smoke -> verified  (CRuby and Spinel agree on real use)
    #   match, require-only     -> loaded    (loads+runs identically; logic untested)
    #   mismatch                -> rejected  (reason: miscompile, with a short diff)
    #   no build                -> rejected  (reason: build-error / run-error)
    #
    # The smoke is the unit of trust. The require-only default smoke only proves
    # the gem loads identically (`loaded`); pass `--smoke FILE` (a snippet that
    # drives the gem's API and prints deterministic output) to actually verify
    # behaviour (`verified`). Verification is only as good as the smoke — which is
    # why it's opt-in and human-supplied. (A `loaded` gem can still silently
    # miscompile in logic the require-only smoke never ran — observed in practice.)
    class Verifier
      HARNESS = "__spinel_verify.rb".freeze

      def initialize(engine, ledger)
        @engine = engine
        @ledger = ledger
      end

      def verify(gem_name, version, dir, smoke: nil)
        @engine.ensure!
        harness = File.join(dir, HARNESS)
        File.write(harness, harness_source(gem_name, dir, smoke))

        ruby_out, _, ruby_ok = run_ruby(harness, dir)
        spin_out, spin_err, spin_ok = run_spinel(harness)

        verdict, reasons = classify(ruby_ok, spin_ok, ruby_out, spin_out, spin_err, behavior: !smoke.nil?)
        @ledger.record(@ledger.build(
          gem: gem_name, version: version, rev: @engine.rev,
          verdict: verdict, reasons: reasons, probe: "verify"
        ))
      ensure
        File.delete(harness) if harness && File.exist?(harness)
      end

      private

      # behavior: true when a real --smoke drove the gem's API (→ `verified` on
      # match); false for the require-only default smoke (→ `loaded` on match —
      # it loaded+ran identically, but its logic wasn't exercised, so a silent
      # miscompile in that logic is still possible).
      def classify(ruby_ok, spin_ok, ruby_out, spin_out, spin_err, behavior:)
        unless ruby_ok
          # Smoke is broken under plain Ruby — can't draw a conclusion.
          return ["risky", ["smoke-error:cruby"]]
        end
        return ["rejected", ["build-or-run-error"] + spin_err.lines.grep(/error|fatal/i).first(2).map(&:strip)] unless spin_ok

        if ruby_out == spin_out
          [behavior ? "verified" : "loaded", []]
        else
          ["rejected", ["miscompile", "diff:#{first_diff(ruby_out, spin_out)}"]]
        end
      end

      # require_relative resolves against the harness's own dir (the gem root),
      # and Spinel inlines it — so this follows require_relative-split gems
      # natively. (Plain `require "gem/part"` gems still under-resolve; that's the
      # documented load-path limitation.)
      def harness_source(gem_name, dir, smoke)
        entry = entrypoint(gem_name, dir)
        body = smoke ? File.read(smoke) : %{puts "spinel-verify: loaded #{gem_name}"}
        src = +""
        src << %{require_relative "#{entry}"\n} if entry
        src << body << "\n"
        src
      end

      # The gem's conventional entry file. Try lib/<gem>.rb, then the require path
      # a dashed name maps to (lib/<a>/<b>.rb for "a-b") — so dashed/nested gems
      # like opentelemetry-semantic_conventions actually load, instead of the
      # require-only smoke silently loading nothing and looking like it passed.
      def entrypoint(gem_name, dir)
        [gem_name, gem_name.tr("-", "/")].uniq.each do |cand|
          return "lib/#{cand}" if File.exist?(File.join(dir, "lib", "#{cand}.rb"))
        end
        nil
      end

      # CRuby is the reference: give it the gem's own lib/ on the load path so a
      # gem's internal plain `require "<gem>/part"` resolves naturally. Spinel
      # gets no such help (no load path is its real constraint) — so a gem that
      # *needs* the load path diverges and is correctly rejected, rather than
      # failing under CRuby too and looking like a broken smoke.
      def run_ruby(file, dir)
        out, err, st = Open3.capture3("ruby", "-I", File.join(dir, "lib"), file)
        [out, err, st.success?]
      end

      def run_spinel(file)
        bin = file.sub(/\.rb$/, ".bin")
        _, cerr, cst = Open3.capture3(@engine.bin, file, "-o", bin)
        return ["", cerr, false] unless cst.success? && File.executable?(bin)

        out, err, st = Open3.capture3(bin)
        [out, (cerr + err), st.success?]
      ensure
        File.delete(bin) if bin && File.exist?(bin)
      end

      def first_diff(a, b)
        al = a.lines
        bl = b.lines
        al.each_index do |i|
          return "L#{i + 1} cruby=#{al[i].inspect} spinel=#{bl[i].inspect}" if al[i] != bl[i]
        end
        "len #{al.size}!=#{bl.size}"
      end
    end
  end
end

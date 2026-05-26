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
    #   match    -> verified  (CRuby and Spinel agree on this smoke)
    #   mismatch -> rejected  (reason: miscompile, with a short diff)
    #   no build -> rejected  (reason: build-error / run-error)
    #
    # The smoke is the unit of trust. A require-only default smoke catches
    # load-time divergence; pass `--smoke FILE` (a snippet that drives the gem's
    # API and prints deterministic output) to verify behaviour. Verification is
    # only as good as the smoke — which is why it's opt-in and human-supplied.
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

        ruby_out, _, ruby_ok = run_ruby(harness)
        spin_out, spin_err, spin_ok = run_spinel(harness)

        verdict, reasons = classify(ruby_ok, spin_ok, ruby_out, spin_out, spin_err)
        @ledger.record(@ledger.build(
          gem: gem_name, version: version, rev: @engine.rev,
          verdict: verdict, reasons: reasons, probe: "verify"
        ))
      ensure
        File.delete(harness) if harness && File.exist?(harness)
      end

      private

      def classify(ruby_ok, spin_ok, ruby_out, spin_out, spin_err)
        unless ruby_ok
          # Smoke is broken under plain Ruby — can't draw a conclusion.
          return ["risky", ["smoke-error:cruby"]]
        end
        return ["rejected", ["build-or-run-error"] + spin_err.lines.grep(/error|fatal/i).first(2).map(&:strip)] unless spin_ok

        if ruby_out == spin_out
          ["verified", []]
        else
          ["rejected", ["miscompile", "diff:#{first_diff(ruby_out, spin_out)}"]]
        end
      end

      # require_relative resolves against the harness's own dir (the gem root),
      # and Spinel inlines it — so this follows require_relative-split gems
      # natively. (Plain `require "gem/part"` gems still under-resolve; that's the
      # documented load-path limitation.)
      def harness_source(gem_name, dir, smoke)
        entry = File.exist?(File.join(dir, "lib", "#{gem_name}.rb")) ? "lib/#{gem_name}" : nil
        body = smoke ? File.read(smoke) : %{puts "spinel-verify: loaded #{gem_name}"}
        src = +""
        src << %{require_relative "#{entry}"\n} if entry
        src << body << "\n"
        src
      end

      def run_ruby(file)
        out, err, st = Open3.capture3("ruby", file)
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

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

      # full: when true, the harness force-requires *every* .rb under the gem's
      # lib/ (not just the entrypoint) before the smoke body. This defeats the
      # `autoload`/lazy-`require` masking that lets a constant-only smoke pass
      # `verified` while the gem's real surface (client/transport/serialization)
      # never compiled — the qdrant-ruby spike (spinelgems#4). The verdict
      # vocabulary is unchanged; the probe is tagged `verify-full` so the
      # whole-surface signal stays distinguishable in the ledger from the
      # entrypoint-only `verify`.
      def verify(gem_name, version, dir, smoke: nil, full: false)
        @engine.ensure!
        harness = File.join(dir, HARNESS)
        File.write(harness, harness_source(gem_name, dir, smoke, full))

        ruby_out, ruby_err, ruby_ok = run_ruby(harness, dir)
        spin_out, spin_err, spin_ok = run_spinel(harness)

        verdict, reasons = classify(ruby_ok, spin_ok, ruby_out, spin_out, spin_err, behavior: !smoke.nil?)
        # Tag *why* (the spinelgems#4 usability rubric) so a failure says what it'd
        # take, not just "rejected". Prepended to reasons as `rubric:<tag>`.
        unless verdict == "verified" || verdict == "loaded" || verdict == "clean"
          reasons = ["rubric:#{rubric(ruby_ok, ruby_err, spin_ok, spin_err, ruby_out, spin_out, gem_name)}"] + reasons
        end
        @ledger.record(@ledger.build(
          gem: gem_name, version: version, rev: @engine.rev,
          verdict: verdict, reasons: reasons, probe: full ? "verify-full" : "verify"
        ))
      ensure
        File.delete(harness) if harness && File.exist?(harness)
      end

      private

      # The spinelgems#4 usability rubric: classify *why* a gem isn't verified,
      # from the CRuby-vs-Spinel attribution + the spinel warnings/errors. One
      # short tag, stored as `rubric:<tag>` in the verdict reasons.
      #
      #   needs-dep      — fails under CRuby too (not self-contained: needs an
      #                    external gem / TLS that the harness doesn't provide)
      #   load-path      — Spinel ignored a plain `require "gem/part"` (no load
      #                    path); the gem's real classes never compiled
      #   needs-stdlib   — Spinel ignored a `require` of a stdlib it doesn't ship
      #   codegen        — a C compile error on ordinary Ruby — a real Spinel bug
      #   miscompile     — compiles + runs, but output diverges from CRuby
      #   unsupported    — a call Spinel can't resolve (silently emits 0)
      #   build-error    — some other build/run failure
      def rubric(ruby_ok, ruby_err, spin_ok, spin_err, ruby_out, spin_out, gem_name)
        unless ruby_ok
          e = ruby_err.to_s
          return "needs-dep" if e =~ /cannot load such file|LoadError|OpenSSL|openssl/i
          return "smoke-error"
        end
        if spin_ok && ruby_out != spin_out
          return "miscompile"
        end
        # spin build/run failure — read the spinel warnings/errors.
        if (m = spin_err.match(/could not be resolved \(no ([^\s)]+?)\.rb/))
          missing = m[1]
          stem = gem_name.tr("-", "_").split("/").first.to_s
          return "load-path" if missing.include?("/") || missing.start_with?(gem_name.tr("-", "/")) || missing.include?(stem)
          return "needs-stdlib"
        end
        return "codegen"     if spin_err =~ /\bout\.c:\d+:\d+: *error:/
        return "unsupported" if spin_err =~ /cannot resolve call|undefined method/
        "build-error"
      end

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
      def harness_source(gem_name, dir, smoke, full = false)
        entry = entrypoint(gem_name, dir)
        body = smoke ? File.read(smoke) : %{puts "spinel-verify: loaded #{gem_name}"}
        src = +""
        if full
          # Entrypoint first (it sets up the module/autoload structure), then
          # every other lib file — forcing the autoload-masked surface to load
          # and compile. No rescue: this is the "do we actually know it works"
          # bar, so a dependency that won't load (e.g. Faraday/TLS) or a file
          # Spinel can't compile is a real failure, not something to swallow.
          # CRuby runs with -I lib, so a require that fails under CRuby too lands
          # as `risky` (gem isn't self-contained), distinct from a Spinel-only
          # `rejected`.
          lib_requires(dir, entry).each do |rel|
            src << %{require_relative "#{rel}"\n}
          end
        elsif entry
          src << %{require_relative "#{entry}"\n}
        end
        src << body << "\n"
        src
      end

      # Every .rb under lib/ as require_relative-able paths (no extension),
      # entrypoint first, the rest sorted for determinism.
      def lib_requires(dir, entry)
        files = Dir[File.join(dir, "lib", "**", "*.rb")]
                .map { |f| f.sub(%r{\A#{Regexp.escape(dir)}/}, "").sub(/\.rb\z/, "") }
                .sort
        files.unshift(entry) if entry # already in `files`; uniq keeps it first
        files.uniq
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

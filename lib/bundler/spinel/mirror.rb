require "fileutils"

module Bundler
  module Spinel
    # Scaffolds a publish-ready **mirror** package skeleton — the shape
    # matz/spinel#1753 settled on for making a spin package out of a rubygems gem
    # whose own source won't compile under the subset. A mirror is NOT a port of
    # the gem's source: it's a narrowed contract reimplemented in the subset,
    # oracled against the *real* gem, with a documented exclusion ledger. The
    # reference shapes are rubys' spinel-redis / spinel-pg.
    #
    # This is a *porter tool*, per matz's explicit redirect: it turns ONE chosen
    # gem into a skeleton a human completes and publishes via PR. It never opens
    # an index PR and never touches spin-index — the corpus/roadmap stays a
    # spinelgems sidecar (compat.jsonl).
    #
    # The three files matter most, mapping to matz's normative naming conditions
    # for claiming the gem's require string:
    #   README.md  exclusion ledger        -> condition #1 (ledgered divergences)
    #   oracle/run.sh                       -> condition #2 (real gem as oracle)
    #   <name>.rb / core.rb doctrine        -> condition #3 (loud failure outside
    #                                          the contract — no method_missing
    #                                          funnel; unknown surface is a
    #                                          compile-time error under Spinel)
    #
    # The exclusion ledger is SEEDED from the gem's own probe record: the
    # `risks` (metaprogramming the mirror must make explicit) and `reasons` (why
    # the gem is rejected — e.g. c-extension) are exactly the surface a mirror
    # narrows, so we pre-fill the ledger with them as TODO rows.
    module Mirror
      module_function

      # Map a probe risk/reason token to a seeded exclusion-ledger row:
      # [surface, disposition, note]. Unknown tokens pass through with a generic
      # note so nothing the probe saw is silently dropped.
      SEED_NOTES = {
        "method_missing" => ["reimplement", "Dynamic dispatch funnel — define each supported call explicitly; unknown calls must fail loudly, never funnel."],
        "define_method"  => ["reimplement", "Dynamic method definition — expand to explicit `def`s over the ledgered surface."],
        "eval"           => ["exclude",     "Runtime `eval` — not in the subset; reimplement statically."],
        "class_eval"     => ["exclude",     "`class_eval` — reimplement statically."],
        "instance_eval"  => ["exclude",     "`instance_eval` — reimplement statically."],
        "module_eval"    => ["exclude",     "`module_eval` — reimplement statically."],
        "send"           => ["narrow",      "Reflective `send` — replace with direct calls across the fixed surface."],
        "public_send"    => ["narrow",      "Reflective `public_send` — replace with direct calls."],
        "c-extension"    => ["reimplement", "Native C-extension — reimplement the *used* surface over FFI / sp_net / pure Ruby (this is why a mirror, not a port)."]
      }.freeze

      # Seeded ledger rows from a probe record (string-keyed, as in the ledger /
      # compat.jsonl). reasons first (hard blockers), then risks (dynamic surface).
      def seeded_exclusions(record)
        return [] unless record
        toks = Array(record["reasons"]) + Array(record["risks"])
        toks.map do |t|
          disp, note = SEED_NOTES.fetch(t.to_s.split(":", 2).first, ["review", "Probe flagged `#{t}` — decide: exclude, narrow, or reimplement."])
          [t, disp, note]
        end
      end

      # Scaffold the package tree. Returns {dir:, files: [rel...], exclusions:}.
      # record: the gem's ledger verdict (for ledger seeding), or nil.
      def scaffold(name:, version: "0.1.0", gem_version: nil, record: nil,
                   engine_rev: nil, out: nil, force: false)
        dir = out || "spinel-#{name}"
        if File.directory?(dir) && !Dir.empty?(dir) && !force
          raise Error, "#{dir} exists and is not empty (pass --force to write into it)"
        end
        klass = const_name(name)
        excl = seeded_exclusions(record)
        files = {
          "spin.toml"                       => spin_toml(name, version),
          "#{name}.rb"                      => require_root(name, klass),
          "#{name}/core.rb"                 => core_stub(name, klass),
          "README.md"                       => readme(name, klass, gem_version, record, engine_rev, excl),
          "oracle/run.sh"                   => oracle_run(name),
          "oracle/smoke.rb"                 => oracle_flow(name, klass),
          "test/#{name}_test.rb"            => dual_runtime_test(name, klass),
          "test/smoke_test.rb.expected"     => "",
          "examples/basic.rb"               => example_basic(name, klass),
          "bin/verify"                      => verify_script(name),
          ".gitignore"                      => "build/\n*.bin\n"
        }
        files.each do |rel, body|
          path = File.join(dir, rel)
          FileUtils.mkdir_p(File.dirname(path))
          File.write(path, body)
        end
        FileUtils.chmod(0o755, File.join(dir, "oracle/run.sh"))
        FileUtils.chmod(0o755, File.join(dir, "bin/verify"))
        { dir: dir, files: files.keys.sort, exclusions: excl }
      end

      # "http-cookie" / "active_support" -> "HttpCookie" / "ActiveSupport".
      def const_name(name)
        name.split(/[-_]/).map { |p| p[0].to_s.upcase + p[1..].to_s }.join
      end

      def spin_toml(name, version)
        <<~TOML
          [package]
          name = "#{name}"
          version = "#{version}"

          # Published repo is conventionally named spinel-#{name}; the package
          # *name* carries no prefix — it claims the gem's require string.
          # `spin publish` appends the [[probe]] compatibility record; do not
          # hand-write it. See matz/spinel#1753 for the mirror naming policy.
        TOML
      end

      def require_root(name, klass)
        <<~RUBY
          # #{name} — a Spinel-subset MIRROR of the #{name} gem.
          #
          # The require string mirrors the #{name} gem so `require "#{name}"`
          # resolves here. This is a MIRROR, not a port: a narrowed contract
          # reimplemented in the subset and oracled against the real gem. What is
          # narrowed or excluded is in README.md's exclusion ledger.
          #
          # LOUD FAILURE (matz/spinel#1753 condition #3): define ONLY the ledgered
          # surface here. Do not add a method_missing funnel — an out-of-ledger
          # call must be an undefined method, which Spinel turns into a
          # compile-time error, never a silent divergence.
          require_relative "#{name}/core"

          # class #{klass} is defined in #{name}/core.rb — re-exported by the
          # require above. Keep the public entry surface here thin.
        RUBY
      end

      def core_stub(name, klass)
        <<~RUBY
          # Core contract for the #{name} mirror. Reimplement here the surface
          # consumers actually call — typed arities, concrete return shapes that
          # match the real gem (verified by oracle/run.sh). Every method is an
          # explicit `def`; nothing dynamic.
          class #{klass}
            def initialize
              # TODO: the mirror's real constructor.
            end

            # TODO: replace with the real ledgered surface. Each method's return
            # shape must match the real gem — that equality is what oracle/run.sh
            # proves against a live #{name}.
            def version
              "0.1.0-mirror"
            end
          end
        RUBY
      end

      def readme(name, klass, gem_version, record, engine_rev, excl)
        verdict = record && record["verdict"]
        gv = gem_version || (record && record["version"])
        ledger = if excl.empty?
          "_No probe signal to seed from — fill this in as you narrow the surface._\n"
        else
          rows = excl.map { |surface, disp, note| "| `#{surface}` | #{disp} | #{note} |" }.join("\n")
          "| surface | disposition | note |\n|---|---|---|\n#{rows}\n"
        end
        provenance = if verdict
          "Seeded from the spinelgems probe of **#{name} #{gv}** " \
          "(`#{verdict}`#{engine_rev ? " @ #{engine_rev}" : ""}). " \
          "The rows below are the probe's `reasons`/`risks` — the surface a mirror " \
          "must narrow — as TODOs, not a finished ledger."
        else
          "No probe record was found for `#{name}`; start the ledger from scratch."
        end
        <<~MD
          # #{name} (spinel-#{name})

          A Spinel-subset **mirror** of the [#{name}](https://rubygems.org/gems/#{name}) gem.
          `require "#{name}"` resolves here; the surface mirrors the gem's contracts,
          so code written against it resolves unchanged — within the exclusion ledger below.

          ```ruby
          require "#{name}"
          # TODO: a minimal usage example that matches the real gem's output.
          ```

          ## Exclusion ledger

          This mirror claims the `#{name}` require string, which under
          [matz/spinel#1753](https://github.com/matz/spinel/issues/1753) is honest only while:

          1. **Divergences are ledgered** — the table below documents everything narrowed vs the real gem;
          2. **The real gem is the oracle** — `oracle/run.sh` verifies the claimed surface differentially against a live #{name} (+ `spin test` diffs the compiled run against CRuby);
          3. **Out-of-ledger surface fails loudly** — undefined methods are compile-time errors (no `method_missing` funnel), never silent divergence.

          #{provenance}

          #{ledger}
          ## Architecture

          - `#{name}.rb` — require root; claims the require string.
          - `#{name}/core.rb` — the ledgered contract (`#{klass}`), explicit `def`s only.
          - `test/#{name}_test.rb` — dual-runtime conformance (no snapshot; `spin test` diffs compiled-vs-CRuby).
          - `oracle/` — replays flows through the **real** #{name} gem and diffs against committed snapshots.

          ## Developing

          ```sh
          bin/verify          # spin test (compiled-vs-CRuby) + oracle/run.sh (vs the real gem)
          sh oracle/run.sh    # real-gem leg only (needs the #{name} gem installed)
          ```
        MD
      end

      def oracle_run(name)
        <<~SH
          #!/bin/sh
          # Oracle harness (matz/spinel#1753 condition #2): replay each snapshot-
          # gated flow through the REAL #{name} gem and diff against the snapshots
          # frozen from the compiled mirror. Proves the real gem derives identical
          # output from identical flows — surface parity with zero hand-authored
          # expectations.
          #
          # Usage: sh oracle/run.sh          (from the repo root)
          # Needs: ruby with the #{name} gem installed (+ any live service it drives).
          set -e
          OUTDIR=build/oracle
          mkdir -p "$OUTDIR"

          fails=0
          ran=0
          # TODO: list each flow whose *_test.rb.expected snapshot is committed.
          for flow in smoke; do
            ran=$((ran + 1))
            ruby "oracle/$flow.rb" > "$OUTDIR/$flow.out" 2>&1 || true
            if diff -u "test/${flow}_test.rb.expected" "$OUTDIR/$flow.out" > "$OUTDIR/$flow.diff" 2>&1; then
              echo "ok   $flow"
              rm -f "$OUTDIR/$flow.diff"
            else
              echo "FAIL $flow (see $OUTDIR/$flow.diff)"
              fails=$((fails + 1))
            fi
          done
          echo "$((ran - fails))/$ran flows match the real #{name}"
          [ $fails -eq 0 ]
        SH
      end

      def oracle_flow(name, klass)
        <<~RUBY
          # Oracle flow: drives the surface through the REAL #{name} gem and prints
          # deterministic output. The SAME flow, run against the compiled mirror,
          # is snapshotted into test/smoke_test.rb.expected — oracle/run.sh diffs
          # this real-gem run against that snapshot.
          require "#{name}"

          # TODO: exercise the ledgered surface with fixed inputs; print results
          # so the mirror's output and the real gem's output are byte-identical.
          puts #{klass}.new.version
        RUBY
      end

      def dual_runtime_test(name, klass)
        <<~RUBY
          # Dual-runtime conformance: no snapshot is committed, so `spin test`
          # diffs the compiled run against CRuby directly (the compiled-vs-CRuby
          # leg of condition #2). Keep assertions to pure-Ruby logic that both
          # runtimes can execute without a live service.
          require_relative "../#{name}/core"

          c = #{klass}.new
          puts "version " + (c.version == "0.1.0-mirror").to_s
          # TODO: add one line per ledgered contract, printing pass/fail.
        RUBY
      end

      def example_basic(name, klass)
        <<~RUBY
          require "#{name}"

          # TODO: a runnable example mirroring the real gem's basic usage.
          puts #{klass}.new.version
        RUBY
      end

      def verify_script(name)
        <<~SH
          #!/bin/sh
          # Local verify loop for the #{name} mirror. Prefers spin's own gate;
          # falls back to a hint while the spin CLI isn't a daily driver yet.
          set -e
          ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
          cd "$ROOT"

          if command -v spin >/dev/null 2>&1; then
            spin test
          else
            echo "spin not on PATH — install it to run the compiled-vs-CRuby gate."
            echo "Meanwhile, the real-gem oracle leg still runs:"
          fi
          sh oracle/run.sh
        SH
      end
    end
  end
end

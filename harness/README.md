# harness/ — try real gems in a real Spinel project

A testbed that exercises the Gemfile convention end-to-end and serves as the
testing ground for the `verified` rung. Two phases.

## Phase 1 — sanity check the structure

A real Spinel project: a convention `Gemfile` (with the `engine: "spinel"`
marker) + the actual flow.

```sh
bundle lock                                   # resolves; ignores the engine marker
../exe/spinel-compat vendor Gemfile.lock --into vendor/spinel
spinel main.rb -o main.bin && ./main.bin      # require_relative "vendor/spinel/deps"
```

This proves Proposal 1 (Gemfile) + 2a (vendor placement): `bundle lock` resolves
normally, `vendor` places each gem's `lib/` and writes a lock-ordered `deps.rb`,
and a Spinel program that `require_relative`s it compiles and runs — identically
to CRuby. (`vendor` also *advises* when a gem is rejected for the current engine
rev; placement still happens — placement and gating are different jobs.)

## Phase 2 — the `verified` testing ground

Per-gem smokes under `smoke/<gem>.rb`. `spinel-compat verify <gem> --smoke
smoke/<gem>.rb` runs the smoke once under CRuby (the reference) and once
Spinel-compiled, and diffs stdout: match → `verified`, divergence →
`rejected:miscompile`.

```sh
for s in smoke/*.rb; do
  g=$(basename "$s" .rb)
  ../exe/spinel-compat verify "$g" --smoke "$s"
done
```

`run.sh` automates both phases.

## What we found (engine git:2183a92+dirty, aarch64-linux)

The whole point of the `verified` rung, demonstrated:

- **Require-only "verified" (loads + compiles identically) is NOT trustworthy.**
  ~22 popular `clean` gems load cleanly under Spinel, but exercising their actual
  behaviour exposes **silent miscompiles**:
  - `strings-ansi`: `sanitize(...)` → CRuby `"RED and bold text"`, **Spinel `"0"`**.
  - `semantic_puppet`: `Version "1.2.3" < "1.10.0"` → CRuby `true`, **Spinel `false`**.
- **Most popular gems reject at compile time** on missing runtime: `String#scan`,
  `Thread::Mutex`, `StringScanner#[]`, variadic methods (`notify_observers`),
  some regex-literal codegen, self-referential class types (`AST::Node`).
- **Multi-file plain-`require` gems can't verify** — they need a load path Spinel
  doesn't have (the verifier gives CRuby `-I lib` so this shows up as a clean
  `rejected`, not a broken smoke).

Net: **0 popular gems are behaviour-`verified` yet.** `clean` (and even
require-only `verified`) massively overstate compatibility; only a behaviour
smoke through this harness is trustworthy. That's the case for the curated
source serving *only* behaviour-verified gems — and a precise roadmap for Spinel.

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

Proves Proposal 1 (Gemfile) + 2a (vendor placement): `bundle lock` resolves
normally, `vendor` places each gem's `lib/` and writes a lock-ordered `deps.rb`,
and a Spinel program that `require_relative`s it compiles and runs — identically
to CRuby. (`vendor` also *advises* when a gem is rejected for the current engine
rev; placement still happens — placement and gating are different jobs.)

## Phase 2 — the `verified` testing ground

Per-gem smokes under `smoke/<gem>.rb`. `spinel-compat verify <gem> [--smoke
smoke/<gem>.rb]` runs the smoke once under CRuby (the reference, with the gem's
`lib/` on the load path) and once Spinel-compiled, then diffs stdout. The verdict
depends on whether a behaviour smoke was supplied:

| run | match | mismatch | no build |
|---|---|---|---|
| `--smoke FILE` (drives the API) | **`verified`** | `rejected:miscompile` | `rejected` |
| require-only (default) | **`loaded`** | — | `rejected` |

`run.sh` automates both phases.

### Why `loaded` ≠ `verified` (the refinement)

`loaded` means "compiles and **loads** identically under CRuby and Spinel" — it
*ran*, but its logic wasn't exercised. That is **not** trustworthy: a gem can
load fine and still silently miscompile in logic the require-only smoke never
touched. Only `verified` — a behaviour smoke that drives the gem's real API and
matches — earns trust (and a curated-source slot). The harness proved the gap is
real, so the rung is split.

## What we found (engine `git:2183a92+dirty/aarch64-linux-gnu`)

Over the surveyed ledger (15,673 gems): **1 verified · 64 loaded · 2219 clean ·
1474 risky · 11915 rejected.**

- **Behaviour-`verified`: `opentelemetry-semantic_conventions`** — a constants
  library, so verifying its constants *is* verifying its function. The only
  popular gem to clear the bar so far.
- **`loaded` is not enough — silent miscompiles, caught only by behaviour:**
  - `strings-ansi`: `sanitize(...)` → CRuby `"RED and bold text"`, **Spinel `"0"`**.
    *Root cause: `\033` octal escape in a regex wasn't honoured. Fixed upstream
    by matz/spinel#1009 (commit 52088bc), and broadened to `\xHH` hex too.*
  - `emoji_regex` (scan): `str.scan(EmojiRegex::Regex)` raised `undefined method
    'scan'`. *Root cause: a regex in a namespaced constant wasn't resolved.
    Fixed upstream by matz/spinel#1008 via our PR #1010 (merged, commit 90227db).*
  - `semantic_puppet`: `Version "1.2.3" < "1.10.0"` → CRuby `true`, **Spinel `false`**.
  - `tty-which`: `exist?("sh")` → CRuby `true`, **Spinel `0`**.
- **Most popular gems reject at compile time** on missing runtime: `Thread::Mutex`,
  `StringScanner#[]`, variadic methods (`notify_observers`), self-referential
  class types (`AST::Node`), and `to_words`/`cantor`-style logic. (`String#scan`
  itself works fine — the original failure was scan with a *namespaced-constant*
  regex, since fixed; see #1008 above.)

The lesson stands even after the fixes: two silent miscompiles in this list were
**only catchable by a differential behaviour run** — a static scan can't see
them. Re-running the harness against fresh upstream is the natural next step
(some `risky`/`rejected` gems should now move up the ladder).
- **Multi-file plain-`require` gems can't verify** — they need a load path Spinel
  doesn't have (the verifier gives CRuby `-I lib`, so this surfaces as a clean
  `rejected`, not a broken smoke).

Net: `clean` and even `loaded` massively overstate compatibility; only a
behaviour smoke is trustworthy — exactly why the curated source serves
`verified` only. And every rejection names a feature: a precise Spinel roadmap.

## Catalog considerations (spinelgems.org)

The catalog renders these verdicts; a few things follow from the above:

- **Default the catalog's "min verdict" to `verified`, not `clean`.** `clean`
  (and `loaded`) are cheap lower bounds that this harness shows are wrong often
  enough that surfacing them as "compatible" would mislead. The chips let a
  visitor opt into the weaker tiers, but the headline count and the Compact Index
  store should be `verified`-only.
- **Show `loaded` distinctly (○), never folded into `verified` (★).** They mean
  different things; the silent-miscompile examples above are the reason.
- **The Compact Index serves `--min verified`.** With one verified gem today the
  store is nearly empty — honest: the curated source promises *behaviour-vetted*
  gems, and there is exactly one. It grows as smokes are added here.
- **Popularity sort + the downloads floor stay.** They make the catalog browsable
  but are orthogonal to trust — a 1B-download gem can still be `rejected`.
- **Verdicts are rev-scoped.** The catalog states the engine rev; a new Spinel
  re-probes and a gem rejected today can flip. The catalog is a snapshot, not a
  verdict for all time.

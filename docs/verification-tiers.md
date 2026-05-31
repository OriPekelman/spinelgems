# Verification tiers — what "verified" actually means

The catalog reports a verdict per gem at a given Spinel engine revision. The
verdicts form a ladder of increasing trust, and the headline lesson of this
project is that **the cheap rungs systematically overstate compatibility**. This
doc explains each tier, why we tightened the `verified` bar to *full-surface*
verification, and the audit that took the catalog from 77 "verified" gems to 16.

## The ladder

| verdict | glyph | what it proves | trust |
|---|---|---|---|
| `rejected` | ✗ | doesn't compile, or compiles to a detected no-op/miscompile | — |
| `risky` | ~ | compiles, but uses constructs Spinel degrades silently (`eval`, `define_method`, …) | low |
| `clean` | ✓ | the static probe compiled it. **No behaviour was run.** | cheap lower bound |
| `loaded` | ○ | entrypoint compiles + loads identically under CRuby and Spinel (require-only differential). **Logic untested.** | weak |
| `verified` | ★ | **full surface** compiles + loads **and** a behaviour smoke matches CRuby | the one to trust |

Each rung is a lower bound for the ones below it and an overstatement of the
ones above. `clean` is the cheapest and the most misleading: a gem can compile
and still miscompile its logic, fail to load a dependency, or silently no-op a
plain `require`.

## Signals — composable, orthogonal to the verdict

The verdict is the **rank** (how far the gem compiled and ran). Layered on top
are **signals** — independent badges a gem can *also* carry. A gem can be ★
verified **and** 👤 human-attested **and** ✪ own-tests-passing at once. We chose
composable badges over a single deeper ladder so each signal stays legible (you
can see *which* evidence a gem has, not just a collapsed rank).

| signal | glyph | what it means | source |
|---|---|---|---|
| human | 👤 | a person has used the gem in a real Spinel/Tep program and attests it works — the **highest-trust** signal we carry | `attestations.jsonl` (version-pinned, git-tracked) |
| tests | ✪ | the gem's **own** test suite compiles, runs, and matches CRuby under a Spinel-compiled harness (`verify --tests`) — stronger than a hand smoke, zero per-gem human effort | `test-results.jsonl` (gated on the current rev) |
| rubric | — | on a **non-verified** gem: *why* not yet — `needs-dep` · `load-path` · `needs-stdlib` · `codegen` · `miscompile` · `unsupported` · `build-error` | the verifier's CRuby-vs-Spinel attribution (`rubric:<tag>` in the ledger) |

**Human attestation** is deliberately the top signal: at current engine maturity,
a person saying "I built on this and it works" outranks any mechanical check —
mechanical verdicts are lower bounds that a real program can still trip past. An
attestation is a `{gem, version, by, date, note, evidence}` record; `Site#rows`
grants 👤 only on a version match, and suppresses it if the gem is
behaviour-rejected at the current rev (a caught regression postdates the
human's "it worked").

**Own-tests (`✪ tests`)** is the strictly-stronger, zero-human-effort behaviour
signal of [#6](https://github.com/OriPekelman/spinelgems/issues/6): the authors'
tests exercise far more than a `VERSION` smoke, and a test that passes CRuby but
fails Spinel-compiled is a pinpointed miscompile → straight into the bug
pipeline. `verify --tests` translates a gem's minitest/test-unit suite into a
Spinel-compilable runner (Ripper-extracted explicit `t.test_x` calls, inlined
assertions — no reflection, no shared polymorphic helper). **Today the badge is
empty:** every verified gem's own suite tried (12 of them, `pr_geohash`,
`haddock`, `ValidateEmail`, …) still surfaces a miscompile the entrypoint smoke
misses — e.g. `ValidateEmail`'s translated suite reports `pass=21 fail=0` under
CRuby but `pass=0 fail=0` Spinel-compiled (the assertions evaporate). That's the
[#6](https://github.com/OriPekelman/spinelgems/issues/6) finding: own-tests push
type-shapes hand-smokes don't, so they hit the whole-program-inference wall
([#1043](https://github.com/matz/spinel/issues/1043)/[#1062](https://github.com/matz/spinel/issues/1062))
sooner than they pass. The mechanism is wired and will light up as that
stabilizes — and in the meantime each failing run is a free bug reproducer.

**Rubric** turns the survey from green/red into "green, and here's what it'd
take" (the [#4](https://github.com/OriPekelman/spinelgems/issues/4) ask): e.g.
`diff-lcs` (1.1B downloads) shows ✗ rejected · *needs load-path*; `tty-cursor`
(214M) shows ✗ rejected · *miscompiles*.

## Why the `verified` bar is *full-surface*

The original `verified` rung only required the gem's **entrypoint** to load plus
a behaviour smoke to match. That turned out to overstate usability in a way the
[qdrant-ruby spike](https://github.com/OriPekelman/spinelgems/issues/4) made
concrete:

- `qdrant-ruby`'s `lib/qdrant.rb` is **all `autoload`** — it `require`s only
  `version.rb`, then lazily autoloads `client.rb` (Faraday), `collections.rb`,
  etc. The smoke printed `Qdrant::VERSION`. So "verified" meant *the version
  constant resolves* — the client/transport code never compiled.
- Spinel has **no load path**, so a plain `require "gem/sub"` is silently
  ignored. A gem like `glicko2` whose `glicko2.rb` does `require "glicko2/rating"`
  loads only its top-level constants under Spinel; `Glicko2::Rating` et al. never
  exist. The entrypoint smoke still "verified" it.

So a constant/VERSION-only smoke earned ★ while the gem's real surface was never
compiled. **Loading is not "you can build on it."**

### `verify --full`

`spinel-compat verify <gem> --smoke <file> --full` force-requires **every** `.rb`
under the gem's `lib/` (entrypoint first, the rest sorted), then runs the smoke —
differentially under CRuby (`-I lib`) and a Spinel-compiled binary, comparing
stdout. The ledger probe is tagged `verify-full`.

It does **not** rescue `LoadError`: a dependency that won't load (e.g.
Faraday/TLS) or a file Spinel can't compile is a *real* failure for "do we know
this works", not something to swallow. A require that also fails under CRuby
(missing external gem) lands as `risky` — "not self-contained" — distinct from a
Spinel-only `rejected`.

`Site#rows` now grants the catalog ★ **only** to gems with a `verify-full`
`verified` verdict (still sticky across engine revisions). An entrypoint-only
`verify` match, and old cross-rev sticky-verifieds with no current smoke, no
longer count.

## The audit (2026-05-29, engine `git:8adbd7b`)

Re-ran all 237 behaviour smokes under no-rescue `--full`:

| outcome | count | meaning |
|---|---|---|
| **verified** | **16** | self-contained; whole `lib/` compiles + loads; smoke matches |
| risky | 93 | full surface needs an external gem (e.g. `qdrant-ruby` → Faraday/TLS) |
| rejected | 128 | Spinel can't compile the full surface (often: real classes behind a plain `require` that Spinel ignores, so they never compile) |

Catalog `verified`: **77 → 16**. Demoted gems fall to their honest tier
(`clean`/`loaded`/`risky`); their behaviour-smoke history stays in the ledger.

Two methodology notes:
- An earlier `--full` pass *did* rescue `LoadError`. That both let
  dependency-needing gems pass spuriously (qdrant-ruby) **and** produced
  `begin/rescue`-wrapped `require_relative` codegen artifacts (false
  `undeclared`-constant rejects). Dropping the rescue fixed both.
- The 16 are a *mechanical* bar (whole surface compiles + smoke matches), not a
  proof of feature-completeness. Some have shallow smokes (`test`,
  `hello-world`, `mime_type_list`); smoke depth is a separate quality axis to
  improve, tracked off the constant-only-smoke list.

## The bug pipeline (matz/spinel)

The harness's primary product is well-scoped engine bugs, not a compat %. From
the 546-gem behaviour pass (filed 2026-05-29):

- **#1044** `.class` on a module → errors/`Integer`
- **#1045** `respond_to?(:m)` false for `def self.m`
- **#1046** `class << self; attr_accessor :x` on a module: `respond_to?` false (regression of closed **#511**)
- **#1047** nested `Module#name`/`Class#name` renders `_` not `::`
- **#1048** `super("…#{x}…")` collapses an interpolated string (still **open**)
- **#1049** `Module#is_a?(Module)` → false (top miscompile — 22 gems)

#1044–1047 and #1049 were **closed** citing commits `8ec9a3b`/`e47419b` — but
those SHAs don't exist on `matz/spinel` master (tip `96b21e6`), the referenced
regression-test files 404, and all five repros **still reproduce** on master.
We've noted this on each (likely local/unpushed commits or agent-cited
non-existent SHAs); the ~30-gem graduation waits on the fixes actually landing.

The cross-class name-based type unification (`matz/spinel#1043`) was reduced to a
gem-free minimal repro — plain `attr_accessor :fd` in two unrelated classes is
enough; `Struct.new` is just one way to spawn the colliding accessor.

## Engine-rev scoping

Verdicts are keyed on the Spinel revision; the catalog renders the dominant rev
in the ledger (currently `a03bb49`, the full-corpus survey). `verify-full`
verdicts at a newer rev (`8adbd7b`) surface the ★ via the cross-rev sticky-verified
rule. A current-rev `rejected` (caught compile error / miscompile) overrides a
historical verified; an old-rev rejection does not (the feature it needed may have
since landed). A future full re-survey at a newer rev re-bases all of this.

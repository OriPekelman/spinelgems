# Scaling the lib ecosystem: tree shaking, linking models, and what a transitive-deps project needs

*Study only (2026-06-11) — no implementation decisions taken here. Companion to
RFC.md (the Gemfile thesis), docs/c-ext.md, and matz/spinel#1367/#1334/#1381.*

## 1. Where the toes actually get stepped on

Spinel is a **whole-program, closed-world** compiler: one input tree, one
`out.c`, types inferred from the union of all call sites. Every scaling worry
traces back to that. The concrete failure modes, each with corpus evidence:

1. **Inference interference (the big one).** A gem's method types are inferred
   from *every* call site in the build — the app's and every other gem's.
   Adding gem B can change how gem A compiles. Verified evidence: tep#205 has
   `Tep::Json.encode_pair_str` blanking output **while SpinelKit::Json is
   byte-clean in the same binary**; #1369 shows a collection degrading
   `PtrArray→poly_array` as more types flow; #1367 shows inference shifting
   with mere file layout. Consequence: **our `verified` tier is per-gem, but
   verification is not compositional.** A project of 10 verified gems is not a
   verified project.
2. **Namespace collisions in one flat world.** Reopened builtins are the
   single biggest rejection cluster at cb23cc6 (#1386: ~270 static + 70
   codegen `'self' undeclared`); a gem named like a stdlib shadows it (the
   `fix/digest-namespace-shadow` branch); all symbols share one C namespace
   (`sp_<sym>`, no stable map yet — matz/spinel#1334).
3. **Require semantics at scale.** Plain `require "other_gem"` is silently
   ignored (no load path) — vendor's topo-ordered `deps.rb` (#19) patches this
   by preloading everything, but circular `require_relative` still
   double-inlines (#1373, minitest's blocker), and a soft dependency outside
   the lockfile stays silently absent.
4. **Analyze cost is superlinear and paid per app build.** `spinel_analyze`
   hits 100+ GB on big single gems (#1302; it has OOM-killed this host's tmux).
   A 50-gem vendor tree is analyzed as one program, on every consumer build.
5. **No package identity / no separate compilation.** The same gem source
   produces different inferred types per consumer (#1367). Nothing about a
   gem's compile is cacheable across apps; nothing is ABI-stable.

(1) and (5) are two faces of the same thing: a gem has no *contract* — its
compiled meaning is whatever this particular program's inference says.

## 2. What a "tree shaker" would mean for Spinel

Three possible layers, two of which partially exist:

| layer | what it removes | status |
|---|---|---|
| **C/link level** | unreferenced emitted functions/data | **already done** — driver compiles `-ffunction-sections -fdata-sections` and links `-Wl,--gc-sections`; codegen also skips some unreached class emission (`cls_emit_skipped`, dead if-arms, `compute_dead_module_class_methods`) |
| **method level, pre-inference** | uncalled methods before the type fixpoint runs | not done; chicken-and-egg (you need some resolution to know reachability) but a name-based over-approximation pass could run before full inference |
| **file/require level** | whole gem files never referenced from the app's reachable graph | not done; the cheapest big cut — `deps.rb` force-loads every gem's entrypoint and the entrypoint inlines the whole gem |

So: **binary size is the already-solved problem; the unsolved prize is
shrinking the world that `spinel_analyze` sees.** A shaker's value, in order:

1. **Analyze time/RSS** (#1302, the binding constraint for "many gems") —
   pruning unreferenced files cuts the fixpoint input directly.
2. **Less interference** — every removed call site is one fewer place that can
   widen or re-unify someone else's types. Mitigation, not cure: two apps
   still infer different types for the gem they share.
3. Binary size — marginal on top of `--gc-sections`.

Precision caveat: Ruby's dynamism (const_get, send, method_missing) makes any
static reachability over-approximate or unsafe. The spinelgems answer is the
usual one — **the differential harness is the safety net**: shake both the
CRuby reference and the Spinel build identically, and over-pruning shows up as
a divergence/error the verify catches, exactly like any other transform.

Interaction with #13 (now landed): shaking *removes call sites*, which creates
more uncalled-but-public methods — precisely what `sig/*.rbs` type roots
re-pin. The two are halves of one idea: **sig declares what a gem means;
the shaker deletes what nobody asked for.**

## 3. Linking models — is whole-program compatible with a large ecosystem?

The honest answer: not by itself. The options, in increasing distance from
today:

**(a) Whole-program, mitigated (near term).** Closed world + file-level shake
+ sig type roots + dedup'd requires. Keeps maximal cross-gem specialization
and zero boundary cost. Still O(app) analyze cost and non-compositional
verification. This is where the catalog lives today.

**(b) Sealed packages: separate compilation behind the sig boundary (the
interesting one).** Compile a gem *once* against its own `sig/` as the
authoritative contract: externally-visible params/returns use the boxed
runtime representation (`sp_RbVal`/poly) at the boundary; internals specialize
freely. The artifact is a `.a`/`.o` plus the sig — cacheable per
`(gem, version, engine rev, sig hash)`, linked into consumers without
re-analysis. Precedent already in-tree: the runtime links `libspinel_rt.a`;
tep's serve path links extracted `sp_net_*` objects; C-ext build-units (#14)
already vendor prebuilt archives. Costs: boxing at gem boundaries (measurable,
likely fine for coarse-grained libs; bad for hot inner loops — those want
model (a) inlining), and it requires upstream work: a stable boundary ABI and
the #1334 symbol map. **This is what makes verification compositional**: a
sealed gem's compiled meaning no longer depends on its consumer, so
`verified` would finally mean verified *everywhere*.
**#13 was the first brick** — sig-as-contract is exactly the boundary
definition a sealed unit needs.

**(c) True dynamic linking (.so per gem).** (b) plus a *stable across
versions* runtime ABI, symbol versioning, loader support. Buys deployment
properties (shared memory, hot swap), not correctness properties beyond (b).
Furthest out; only worth it after (b) exists.

Recommendation to carry into the upstream conversation (when matz is back):
**(a) now, (b) as the RFC** — "sealed packages: compile gems against their RBS
boundary" — citing #1367 (needs package identity), #1334 (needs symbol map),
#1381 (where tooling ships), #13/tep#199 (sig infrastructure exists), and
tep#205 (interference is real and observed). Hold filing per the current
quiet period; draft lives here.

## 4. The transitive-deps project, end to end (validated gems only)

What exists today, in pipeline order, and what's missing at each stage:

| stage | exists | gap |
|---|---|---|
| declare | Gemfile + `engine: "spinel"` marker (matz/spinel#925); gem stays normal | — |
| resolve | `bundle lock` (ordinary Bundler) | resolution ignores the catalog: it can pick a version we never verified. The **curated Compact Index** (`serve` / `build-index`) already exists — pointing the Gemfile's source at it would make Bundler *unable* to resolve unvetted versions. Needs: index coverage (see below) |
| gate | `spinel-compat check [--strict]` against the ledger | engine-rev pinning is convention (deploy-pin-pair memory), not tooling: nothing records "this lockfile was verified at rev X". A `.spinel-rev` written at vendor time + a `check` warning on mismatch is a small, real win |
| place | `vendor`: topo-ordered `deps.rb` (#19), `$LOAD_PATH` prelude for CRuby parity, C-ext build-units (#14), sig aggregation (#13) | file-level shake (§2) to keep analyze tractable as gem count grows |
| compile | `spinel app.rb --rbs vendor/spinel/sig` | — (until (b), scale limits from §1.4 apply) |
| trust | per-gem `verified` (full-surface + behaviour smoke) | **composition**: nothing verifies gems *together* (§1.1) |

The coverage gap behind "resolve": 158 ★ verified is thin, and — the sharper
point — **the verified set is not closed under dependencies.** A project can
only be all-verified if its lockfile's entire closure is. Two catalog moves
follow:

1. **Verified-closure flag.** For each verified gem, check whether its
   transitive runtime deps are all verified; surface "✪ closure" in the
   catalog and make it the bar for the curated index. The dep-graph machinery
   from the load-bearing-gems branch already computes transitive closures over
   the local cache.
2. **Closure-directed harvesting.** Prioritize behaviour smokes for gems that
   *block* a popular verified gem's closure (highest leverage per smoke —
   same logic as load-bearing centrality, restricted to the verified
   frontier).

And the composition gap gets its own rung:

3. **Compositional verify (new harness tier).** For pairs/sets that co-occur
   in real lockfiles: one binary, both gems' smokes, diff vs CRuby. Catches
   exactly the tep#205 class of failure (A fine alone, A broken next to B).
   Cheap to pilot: take the ~160 verified gems, build co-occurrence pairs from
   popular lockfiles, run pairwise. A failed pair is also a *minimal
   interference reproducer* — premium upstream bug material, and the
   quantitative case for §3(b).

## 5. How spinelgems can help, ranked

1. **Compositional verify rung** (§4.3) — proves/quantifies the central risk;
   generates the evidence the sealed-packages RFC needs. No compiler changes.
2. **Verified-closure flag + closure-directed harvesting** (§4.1–2) — makes
   "a real project, all dependencies validated" an achievable, visible state.
   No compiler changes.
3. **Vendor-level file shake experiment** — prune gem files unreferenced from
   the app's require/constant graph, identically for CRuby and Spinel; measure
   analyze time/RSS deltas on tep + a fat lockfile. Data for §2; the harness
   catches over-pruning. No compiler changes (a `--shake` flag on vendor).
4. **Engine-rev pinning in tooling** (`.spinel-rev` at vendor, `check` warns) —
   small; turns the deploy-pin-pair discipline into a guardrail.
5. **Analyze-cost curve** — vendored-gem-count vs `spinel_analyze` time/RSS on
   one app; one chart that makes the scaling argument legible upstream.
6. **Sealed-packages RFC draft** (§3b) — written here, filed when upstream
   wakes.

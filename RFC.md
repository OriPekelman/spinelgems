# RFC: Dependency management for Spinel-compiled Ruby

**Status:** draft (for discussion on a Spinel issue)
**Author:** Ori Pekelman
**Prototype:** [`bundler-spinel`](./README.md) — working MVP, see [ARCHITECTURE.md](./ARCHITECTURE.md)

## Summary

Spinel compiles whole Ruby programs to native C. It has no package layer, and —
by design — no gems, eval, or metaprogramming. Today every project that targets
Spinel (Tep, Toy, …) invents its own ad-hoc vendoring. This RFC proposes a
dependency story that **reuses Bundler's resolver and lockfile** and adds a thin,
**forward-compatible compatibility ledger**, so that incompatible dependencies
fail at **`bundle lock` time** rather than at compile time (where Spinel silently
emits a no-op) or never. It also proposes four small, optional Spinel hooks that
would make compatibility detection first-class instead of inferred.

We deliberately make **no new dependency-format design choices**: a Spinel
project declares deps in a standard `Gemfile`.

## Motivation — two facts that make the naive path dangerous

These are empirical (verified, Bundler 2.7.2 / CRuby 3.4.6):

1. **Bundler can't gate engine compatibility.** There is no `required_ruby_engine`
   gemspec field; `required_ruby_version` is engine-blind; you can't fabricate a
   platform variant for a gem you don't publish. The Gemfile directive
   `ruby "3.3", engine: "spinel", engine_version: "0.0.1"` is a *post-resolution*
   check: `bundle lock` ignores it (exit 0, resolves fine); only `bundle install`
   fires the guard (exit 18, "Your Ruby engine is ruby, but your Gemfile specified
   spinel"). Using `ruby "3.x-spinel"` is strictly worse — it parses to a fake
   prerelease and yields the same install-only timing with a worse message.

2. **Spinel doesn't fail loudly on unsupported Ruby.** It prints
   `warning: … cannot resolve call to 'eval' … (emitting 0)` to stderr and
   degrades the call to a no-op, exiting **0**. Some constructs (`define_method`,
   and *silent miscompiles* such as local-var-name collapse and Int-`0`-as-`nil`)
   produce no warning at all. So **"it compiled" ≠ "it works."**

Net: an incompatible dependency is invisible to resolution and may be invisible
at compile time too. We need to move the decision to resolution time and ground
it in actually running Spinel.

Empirical reality check: of the small pure-Ruby gems we probed (`rake`, `paint`,
`colorator`, `tomlrb`, `version_gem`, `ruby2_keywords`), **all rejected** — some
for genuine metaprogramming, some inflated by Spinel's lack of a load path (see
Ask #4). The compatible *third-party* ecosystem is effectively empty today. That
reframes the goal: the load-bearing artifacts are **your own vetted gems** and
**`path:`/`git:` siblings** (e.g. Tep), not a filtered mirror of rubygems.

## Design (external, built today)

One **append-only ledger** keyed on `(gem, version, engine_rev)`. Three consumers,
all views over it:

- **Lock-time gate** (`bundle spinel-lock`): `bundle lock`, then verdict-check
  every locked gem; exit non-zero on any `rejected`, with feature-named reasons.
- **Curated source** (`spinel-compat serve`): a Compact Index source serving only
  vetted gems. `bundle lock` against it resolves only vetted gems; absent →
  resolution failure (exit 7). Caveat: Bundler also considers locally-installed
  gems, so this gates a clean env (CI); the gate above is the dev-machine backstop.
- **Platform-variant opt-in** (designed): mark `verified` gems with a `spinel`
  platform, JRuby-style, so stock platform resolution prefers them.

**Verdict ladder** (Spinel's failure modes aren't exit codes, so one signal is
insufficient):

| Verdict | Earned by | Trusted by |
|---|---|---|
| `rejected` | `cannot resolve call to 'X'`, or analyze-failed / non-zero exit | gate fails the lock |
| `risky` | compiles clean, but static scan found silently-degraded constructs | gate allows; `--strict` fails |
| `clean` | compiles clean, no risky constructs | gate allows |
| `verified` | `clean` **and** a smoke runs identically under CRuby and Spinel | curated source + platform badge |

The `verified` rung is differential testing and is the only thing that catches
silent miscompiles. Demonstrated: a `h[k].nil? ? -1 : v` lookup over a stored `0`
probes `clean` but verify catches `rejected:miscompile` (`cruby="-1" spinel="0"`).

### Forward compatibility is the core property

Spinel ships **no version** (`spinel --version` prints usage; `git describe` is a
bare SHA). We key every verdict on the Spinel **revision** (git SHA of the
checkout, else a binary hash). Upgrade Spinel → new rev → cache miss → automatic
re-probe. A `rejected` verdict is *never* permanent: it says "rejected as of this
rev, because of these named features." When a feature lands, the next probe
clears it — no hand-maintained blocklist. `reprobe` sweeps known gems under a new
rev to surface what newly passes.

## Asks of Spinel (the upstream proposal)

The external tool works by *inferring* what Spinel can do. Four small, optional
hooks would make it robust and first-class. Ranked by leverage:

1. **A non-zero exit / structured report for unsupported constructs.** Today
   `eval`, `send`, `method_missing`, `define_method` all compile to a no-op with
   an exit-0 warning. A `spinel --check FILE` (or `--strict`) that exits non-zero
   and emits machine-readable diagnostics (JSON: `{unsupported:[{call,loc}], …}`)
   would replace stderr-scraping with a contract. **This is the highest-leverage
   ask** — it turns "compiled" into a real signal.

2. **A stable engine identity.** `spinel --version` (or `--print-rev`) emitting a
   monotonic id. We currently hash the binary / read the git SHA; an official id
   lets the ledger key and the `engine_version:` Gemfile directive line up.

3. **A capability manifest.** `spinel --capabilities` listing supported builtins /
   constructs, so a probe can do set-difference (gem's required features − engine
   capabilities) instead of compile-and-grep, and `reprobe` can target only gems
   whose rejection reasons name newly-added capabilities.

4. **A load path.** Plain `require "x"` resolves only against `<spinel>/lib`, so a
   gem's own split files and stdlib deps don't resolve and the probe under-counts
   (e.g. `tomlrb` rejects partly because its `require "tomlrb/parser"` is unfollowed).
   An `-I DIR` / `--lib-path` would let multi-file gems and stdlib shims resolve,
   making real probing possible — and would help every Spinel consumer, not just
   this tool.

None are required for the external tool to function; each removes a class of
inference and false verdicts.

## Dogfooding

The curated source should be served by **Tep** — which itself compiles via
Spinel. The dependency-manager's source then *is* a Spinel program. The MVP is
CRuby/WEBrick; porting to Tep both validates the approach and exercises Spinel on
digest + JSONL parsing (good probe targets). See ARCHITECTURE.md §"Dogfooding".

## Application to the sibling projects

- **Tep** — the prime *vetted gem*: it exists to compile via Spinel, has no
  external gem deps (its HTTP/JSON/socket layers are in-house C+Ruby). `verify`
  it with a boot-a-handler smoke; publish to the curated source. Replaces the
  rsync-into-`_tep_lib` vendoring that Toy does today with `gem "tep", git:`.
- **Toy** — a *consumer*. Its `lib/` is its own code (already Spinel-compiled for
  the demos); ggml stays FFI (vendored C, not a gem). Its Gemfile is the engine
  directive + `gem "tep"` from the curated/git source. The hand-ordered
  concatenation in `prep/build_tep_app.sh` (a workaround for Tep dropping external
  `require_relative`) is exactly what a real dependency layer removes.
- **Tao** — currently a *CRuby* sibling (ML-homelab, minitest, no Gemfile,
  consumes Toy's JSONL events). It is the clean boundary case: not Spinel-targeted,
  so it keeps a normal Gemfile with **no** engine directive — the directive is
  precisely what separates Spinel-targeted projects from CRuby ones. If/when Tao
  grows a Spinel-compiled component, it becomes a consumer like Toy.

## Proposal to Roundhouse

Toy's `lowerer-design.md` envisions a Roundhouse-style preprocessor (Sam Ruby's
typed-accessor refactoring) that lowers Ruby to typed forms *before* Spinel sees
them. That lowerer is a build stage; `bundler-spinel` is the stage before it. We
propose Tep adopt the pipeline **resolve+vet (bundler-spinel) → lower (Roundhouse)
→ compile (Spinel)**, with the compat ledger as the shared contract: the lowerer
need only handle inputs that the ledger has marked compilable, and a lowering that
changes compatability is itself a probe target. This keeps each stage honest
about what the next can accept.

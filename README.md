# SpinelGems — the Spinel compatibility catalog

> ⚠️ **Pre-release / experimental** (`0.1.0`). The verdict vocabulary and the
> ledger format may still change. Browse the live catalog at
> **<https://spinelgems.org>**.

**Which of the ~189k gems on rubygems.org compile under [Spinel](https://github.com/matz/spinel)'s
subset today — and so could become [`spin`](https://github.com/matz/spinel/blob/main/docs/spin.md) packages.**

Spinel is an ahead-of-time Ruby compiler that accepts a deliberately-growing
**subset** of Ruby. Its package manager is `spin`: a `spin.toml` manifest
resolved against the serverless [spin-index](https://github.com/matz/spin-index)
(no gemspec, no runtime `require`, no tarballs — sources splice into one
whole-program AOT compile). Gems and spin packages are separate worlds; they meet
only at the **name** — a rubygems name reused in spin means *"the same library,
possibly a subset-compatible port."*

SpinelGems is the compatibility oracle underneath: a wholesale survey of the
ecosystem, re-classified at each engine revision by whether each gem actually
compiles under the subset. It exists to answer two questions:

- **What could be ported?** The `clean` / `loaded` / `verified` tiers are the
  candidate pool for spin-package ports — gems whose source already compiles.
- **What should Spinel learn next?** Every `rejected` reason names the missing
  feature; the cross-gem histogram is a prioritized roadmap, and the differential
  harness files the caught miscompiles upstream as focused bugs.

The corpus is the [intended seed](https://github.com/matz/spinel/blob/main/docs/internals/spin.md)
for spin-index, and its per-revision verdicts mirror spin-index's own probe
records (which compiler build a release passed or failed under).

> **History.** This project began as [#925](https://github.com/matz/spinel/issues/925),
> an RFC to borrow a `Gemfile` as an interim dependency convention. That was
> **superseded by `spin`** (2026-07). The `bundler-spinel` gem — the
> `spinel-compat` probe/harness/vendor toolbelt — lives on as the *measurement
> engine* behind the catalog; the Gemfile-consumption path is retired in favour
> of `spin`.

## The measurement engine (`spinel-compat`)

The catalog is built by two passes over the corpus:

1. **Compile + scan** — each gem's `lib/` entrypoints compile as a Spinel program;
   the diagnostics classify it `clean` / `risky` / `rejected`. A cheap lower bound:
   "the C came out," not "it works."
2. **Differential CRuby parity** — for the ones that compile, a behaviour smoke
   runs under CRuby and Spinel and the outputs are diffed. Match → `verified`;
   mismatch → a caught miscompile, filed upstream. Same CRuby-as-oracle method
   `spin test` uses.

## Quick start

```sh
gem install bundler-spinel
spinel-compat install-engine        # fetch + build the Spinel compiler (cached)

spinel-compat probe tzinfo 2.0.6    # probe one gem at the current engine
```

Rebuild the whole catalog at a new engine revision:

```sh
SPINEL_DIR=~/sites/spinel bin/reprobe-corpus.sh   # ~189k gems, xargs -P shards
bin/harness-run.sh                                # differential CRuby-parity smokes
spinel-compat build-site --out public             # render the static catalog site
```

> **The compiler builds from source.** `spinel-compat install-engine` clones
> [Spinel](https://github.com/matz/spinel) and runs `make` (a few minutes, once
> per revision; needs `git` + `make` + a C compiler), caching the result under
> `~/.cache/spinel/`. This will become near-instant once there are **prebuilt
> binaries per platform** — but Spinel is pre-release and moving fast (no stable
> tags yet, revisions land daily), so building from source is deliberate for now:
> it's portable, needs no release pipeline, and always matches the *exact* engine
> revision your compatibility verdicts are keyed on. Prebuilts come once the
> engine stabilizes; we're not there yet.

Verdicts: `★ verified` · `○ loaded` · `✓ clean` · `~ risky` · `✗ rejected`. Trust
`verified` (a behaviour smoke matches CRuby); `clean`/`loaded` are cheap lower
bounds. [What the verdicts mean →](https://spinelgems.org)

## More

- [RFC.md](RFC.md) — the original [#925](https://github.com/matz/spinel/issues/925) proposal (superseded by `spin`, kept for history).
- [docs/cli.md](docs/cli.md) — the full `spinel-compat` toolbelt, verdict ladder, env vars.
- [docs/adoption.md](docs/adoption.md) — extracting libraries + the (legacy) Gemfile convention.
- [ARCHITECTURE.md](ARCHITECTURE.md) — how the gate, the ledger, and the verify rung work.
- [harness/](harness/README.md) — the behaviour-`verified` testing ground (and bug pipeline).
- [docs/verification-tiers.md](docs/verification-tiers.md) — why `verified` means *full surface*.
- [docs/deploying-tep-on-upsun.md](docs/deploying-tep-on-upsun.md) — the catalog site is itself a Spinel-compiled [Tep](https://github.com/OriPekelman/tep) app.
- [docs/related.md](docs/related.md) — the two unrelated "Spinel" projects, `rv`, and `rubocop_spinel`.

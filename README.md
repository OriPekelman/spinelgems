# bundler-spinel

> ⚠️ **Pre-release / experimental** (`0.1.0`). The CLI surface, the verdict
> vocabulary, and the ledger format may still change. Browse the live catalog at
> **<https://spinelgems.org>**.

**Use a standard `Gemfile` for your [Spinel](https://github.com/matz/spinel) project.**

[Spinel](https://github.com/matz/spinel) is a new ahead-of-time Ruby compiler.
Spinel projects have no shared way to declare or exchange dependencies, so each
vendors by hand. Rather than invent a package manager, we propose a plain
`Gemfile` — for two reasons:

- **Share Spinel code.** A `Gemfile` (with `path:` / `git:` siblings) becomes the
  preferred way to declare and exchange dependencies *between* Spinel projects.
- **Reach the Ruby ecosystem.** The same `Gemfile` lets a Spinel project pull from
  the enormous existing body of Ruby gems.

The catch: **most gems won't compile under Spinel yet.** Its scope is deliberately
limited and still growing. So we surveyed the ecosystem and publish a
**[catalog](https://spinelgems.org)** of what works today, at each engine revision.

## The bundler plugin

`bundler-spinel` makes the convention practical in two ways:

1. **Makes it work** — Spinel has no load path and inlines `require_relative`, so a
   dependency has to be *placed* where Spinel will follow it. `spinel-compat vendor`
   does that from a lockfile.
2. **Gates** — Spinel silently no-ops unsupported Ruby (exit 0), so "it compiled"
   ≠ "it works". The plugin probes gems and flags incompatible ones at `bundle lock`
   time, with reasons that name the missing feature.

## The Gemfile convention

```ruby
source "https://rubygems.org"
ruby "3.3.0", engine: "spinel", engine_version: "0.0.0"

gem "tep", git: "https://…/tep.git"   # siblings via path:/git:
gem "some_pure_ruby_lib"
```

`bundle lock` resolves normally (it ignores the engine marker); the marker guards
`bundle install`. Nothing here is novel — that's the point.

## Quick start

```sh
gem install bundler-spinel
spinel-compat install-engine       # fetch + build the Spinel compiler (cached)
spinel-compat init my_app          # scaffold a Gemfile + app.rb + bin/build
cd my_app && bundle install && ./bin/build
```

Or add the gate to an existing project:

```sh
bundle plugin install bundler-spinel
bundle spinel-lock                 # bundle lock + report incompatible gems
spinel-compat vendor               # place deps -> vendor/spinel/<gem>/lib + deps.rb
spinel-compat check Gemfile.lock   # gate: exit 1 if any gem is rejected
```

Then `require_relative "vendor/spinel/deps"` from your Spinel entrypoint.

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

- [RFC.md](RFC.md) — the proposal.
- [docs/cli.md](docs/cli.md) — the full `spinel-compat` toolbelt, verdict ladder, env vars.
- [docs/adoption.md](docs/adoption.md) — adopting the convention + extracting libraries.
- [ARCHITECTURE.md](ARCHITECTURE.md) — how the gate, the ledger, and the verify rung work.
- [harness/](harness/README.md) — the behaviour-`verified` testing ground (and bug pipeline).
- [docs/verification-tiers.md](docs/verification-tiers.md) — why `verified` means *full surface*.
- [docs/deploying-tep-on-upsun.md](docs/deploying-tep-on-upsun.md) — the catalog site is itself a Spinel-compiled [Tep](https://github.com/OriPekelman/tep) app.
- [docs/related.md](docs/related.md) — the two unrelated "Spinel" projects, `rv`, and `rubocop_spinel`.

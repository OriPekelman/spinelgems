# bundler-spinel

> ⚠️ **Pre-release / experimental** (`0.0.1.pre`). The CLI surface, the verdict
> vocabulary, and the ledger format may all change before `0.0.1`. Install with
> `--pre`. (`spinelgems.org` is not live yet.)

**Use a standard `Gemfile` for your [Spinel](https://github.com/matz/spinel)
project — for now.** Spinel-compiled projects have no shared way to declare or
exchange dependencies, so each vendors by hand. Rather than design a package
manager, borrow a format everyone already knows and revisit later. See
[RFC.md](RFC.md) for the proposal, and [docs/adoption.md](docs/adoption.md) for a
project's how-to — adopting the convention *and* breaking a project into
extractable libraries (so a consumer depends on just the slice it needs).

`bundler-spinel` is a small Bundler plugin that makes that practical in two ways:

1. **Makes it work** — places resolved dependencies where Spinel can actually
   find them. Spinel has no load path and inlines `require_relative`, so a dep
   has to be *placed* and wired. `spinel-compat vendor` does that from a lockfile.
2. **Gates** — Spinel silently emits a no-op for unsupported Ruby (exit 0), so
   "it compiled" ≠ "it works". The plugin probes gems and flags incompatible ones
   at `bundle lock` time, with reasons that name the missing feature — nicer than
   a silent miscompile. Verdicts are forward-compatible (keyed on the Spinel rev).

## The Gemfile convention

```ruby
source "https://rubygems.org"
ruby "3.3.0", engine: "spinel", engine_version: "0.0.0"

gem "tep", git: "https://…/tep.git"   # siblings via path:/git: (replaces rsync)
gem "some_pure_ruby_lib"
```

`bundle lock` resolves normally (it ignores the engine marker); the marker guards
`bundle install` (exit 18 under CRuby). Nothing here is novel — that's the point.

## Quick start

```sh
# 1. make it work — place deps where Spinel finds them
bundle lock
exe/spinel-compat vendor                 # -> vendor/spinel/<gem>/lib + vendor/spinel/deps.rb
#    then `require_relative "vendor/spinel/deps"` from your Spinel entrypoint

# 2. gate — flag what Spinel can't compile, early
exe/spinel-compat check Gemfile.lock     # exit 1 if any gem is rejected
```

As a Bundler plugin:

```sh
bundle plugin install bundler-spinel --git https://github.com/OriPekelman/spinelgems.git   # or --path .
bundle spinel-lock      # bundle lock, then report incompatible gems
bundle spinel-check     # gate an existing Gemfile.lock
```

## The rest of the toolbelt

```sh
exe/spinel-compat engine                 # detected compiler + engine rev
exe/spinel-compat probe rake [--dir P]   # probe one gem (or a local/sibling dir)
exe/spinel-compat verify NAME --smoke F  # differential CRuby-vs-Spinel run -> verified
exe/spinel-compat survey --list F        # wholesale review -> reason histogram
exe/spinel-compat serve --store DIR      # curated source (only vetted gems)
exe/spinel-compat ledger / reprobe       # inspect / re-probe under current rev
```

Verdicts: `✗ rejected` · `~ risky` · `✓ clean` · `○ loaded` · `★ verified`.
`clean` compiles; `loaded` also *runs* a require-only differential; `verified`
also passes a behaviour smoke. Trust `verified` — `clean`/`loaded` are cheap
lower bounds (a `loaded` gem can still silently miscompile in untested logic).

## Environment

- `SPINEL_DIR` — path to the Spinel checkout (default `~/spinel`; falls back to a `spinel` on `PATH`).
- `SPINEL_COMPAT_LEDGER` — ledger path (default `ledger/compat.jsonl`).

## Status

Working: the Gemfile convention, `vendor` (placement), the lock-time gate +
Bundler plugin, the probe + forward-compat ledger, the `verified` differential
harness, the curated source (`serve`), and the wholesale `survey`.

The probe is a **lower bound** — Spinel's lack of a load path means multi-file
plain-`require` gems under-probe, and silent miscompiles are invisible to it.
Trust `verified` (smoke runs identically under CRuby and Spinel), not `clean`,
where it matters. Empirically most third-party gems reject today, so the weight
is on your own vetted gems and `path:`/`git:` siblings — not a rubygems mirror.

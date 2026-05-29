# `spinel-compat` — the toolbelt

The full CLI behind the Bundler plugin. The common path (`vendor`, `check`, the
`spinel-lock`/`spinel-check` plugin commands) is covered in the
[README](../README.md#quick-start); this is the rest.

```sh
exe/spinel-compat engine                 # detected compiler + engine rev
exe/spinel-compat probe rake [--dir P]   # probe one gem (or a local/sibling dir)
exe/spinel-compat verify NAME --smoke F  # differential CRuby-vs-Spinel run -> verified
exe/spinel-compat verify NAME --full     # whole-surface verify (force-require every lib file)
exe/spinel-compat survey --list F        # wholesale review -> reason histogram
exe/spinel-compat build-db --out F.db    # materialize the catalog into a SQLite DB
exe/spinel-compat build-site --out DIR   # render the static catalog/site
exe/spinel-compat serve --store DIR      # curated source (only vetted gems)
exe/spinel-compat server --public DIR    # serve the built site + Compact Index
exe/spinel-compat ledger / reprobe       # inspect / re-probe under current rev
```

## Verdict ladder

`✗ rejected` · `~ risky` · `✓ clean` · `○ loaded` · `★ verified`

- **clean** — compiles (a cheap static lower bound; no behaviour run).
- **loaded** — also loads identically under CRuby and Spinel (require-only differential); logic untested.
- **verified** — also passes a behaviour smoke that matches CRuby, with the whole
  surface compiled (`--full`). The only verdict to trust. See
  [verification-tiers.md](verification-tiers.md).
- **risky** — compiles, but uses constructs Spinel degrades silently (`eval`, `define_method`, …).
- **rejected** — doesn't compile, or a caught miscompile — each reason names the missing feature.

Verdicts are keyed on the Spinel engine revision and forward-compatible: a gem
rejected today clears the moment the feature it needs lands.

## Environment

- `SPINEL_DIR` — path to the Spinel checkout (default `~/spinel`; falls back to a `spinel` on `PATH`).
- `SPINEL_COMPAT_LEDGER` — ledger path (default `ledger/compat.jsonl`).
- `SPINEL_COMPAT_CACHE` — gem-source cache dir (default `~/.cache/spinel-compat/gems`).

## Status

Working: the Gemfile convention, `vendor` (placement), the lock-time gate + Bundler
plugin, the probe + forward-compat ledger, the `verified` differential harness
(incl. `--full`), the catalog DB + site, the curated source (`serve`), and the
wholesale `survey`.

The probe is a **lower bound** — Spinel's lack of a load path means multi-file
plain-`require` gems under-probe, and silent miscompiles are invisible to it.
Trust `verified`, not `clean`, where it matters. Empirically most third-party gems
reject today, so the weight is on your own vetted gems and `path:`/`git:` siblings
— not a rubygems mirror.

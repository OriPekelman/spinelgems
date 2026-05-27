# site/ — spinelgems.org source

Base structure for the public site. Built into a static deploy tree by:

```sh
spinel-compat build-site --out public                 # presentation + catalog
spinel-compat build-site --out public --store vetted/ # + Compact Index (apex double-duty)
```

## Apex double-duty

One origin, one static host, two consumers — they don't collide because the
Compact Index reserves only specific paths and the human site owns the rest:

| path | served to | source |
|---|---|---|
| `/` (`index.html`) | browser | `site/index.html` (hand-written) |
| `/catalog.html` | browser | rendered from `ledger/compat.jsonl` at the current engine rev |
| `/assets/style.css` | browser | `site/assets/` |
| `/versions` `/names` `/info/<gem>` `/gems/<file>.gem` | Bundler | `Proxy#write_static` over a `--store` of vetted `.gem` files |

So `source "https://spinelgems.org"` in a `Gemfile` resolves against the curated
source, while a browser at the same origin gets the website.

## What's here vs generated

- **Hand-written:** `index.html` (presentation), `assets/style.css`.
- **Generated** by `Site` (`lib/bundler/spinel/site.rb`): `catalog.html` — the
  human view of the compatibility ledger (the same verdicts the gate and the
  curated source are built on).
- **Generated** by `Proxy` when `--store` is given: the Compact Index files.

## Status

Static + CRuby-rendered today. The dogfood target is to serve the identical tree
from a Spinel-compiled Tep app (see `ARCHITECTURE.md` §Dogfooding). The catalog
needs a populated ledger; the Compact Index needs a store of vetted `.gem`
artifacts (empirically most third-party gems reject, so the store is curated and
small — start with our own verified siblings).

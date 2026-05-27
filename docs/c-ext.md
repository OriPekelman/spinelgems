# C extensions in the vendor flow (design)

**Status:** design · the one piece `spinel-compat vendor` doesn't yet handle.

`vendor` places a gem's `lib/` (Ruby). A gem with a **C extension** — tep's
`sphttp` / `sqlite` / `pg` — needs more: its `.c` compiled to a `.o` and that
`.o` linked into the final Spinel binary. Today the consumer hand-rolls it
(toy's `prep/sync_tep.rb` substitutes `@TEP_SPHTTP_O@` with the prebuilt `.o`
path). This proposes folding that into `vendor`.

## How Spinel links a C extension (verified)

The gem's Ruby declares the link with a top-level directive:

```ruby
module Sock
  ffi_cflags "@TEP_SPHTTP_O@"          # net.rb
  ffi_func :sphttp_listen, [:int, :int], :int
  # …
end
```

- the codegen lowers `ffi_cflags "X"` to a `/* SPINEL_CFLAGS: X */` comment in
  the generated C;
- the `spinel` driver `sed`s `SPINEL_CFLAGS:` out and passes it to the final
  `cc … $FFI_CFLAGS …` link (matz/spinel#514 — auto-link, no extra flags).

**The constraint that forces a placeholder:** `ffi_cflags` takes a *string
literal* — Spinel doesn't evaluate `__dir__` or `ENV.fetch` there. So the `.o`
path can't be computed in the source; it's injected by build-time substitution
of a placeholder (`@TEP_SPHTTP_O@`). tep does this in `bin/tep` (env-driven:
`TEP_SPHTTP_O`); toy replicates it in `sync_tep.rb`. There's no way around the
substitution — so `vendor` should own it.

## The convention: a gem declares its Spinel C extensions

A gem with C extensions ships, alongside its `lib/`:

1. the `.c` source(s),
2. `ffi_cflags "@PLACEHOLDER@"` directives (as today), and
3. a **`spinel-ext.json`** manifest at the gem root (in `s.files`, so it survives
   `gem unpack`):

```json
[
  { "name": "sphttp", "placeholder": "@TEP_SPHTTP_O@",
    "source": "lib/tep/sphttp.c", "cflags": ["-O2"] },

  { "name": "sqlite", "placeholder": "@TEP_SQLITE_O@",
    "source": "lib/tep/tep_sqlite.c", "cflags": ["-O2"],
    "pkg_config": "sqlite3", "pkg_config_fallback": "-lsqlite3",
    "optional": true, "disabled_cflags": "-DNO_SQLITE" },

  { "name": "pg", "placeholder": "@TEP_PG_O@",
    "source": "lib/tep/tep_pg.c", "cflags": ["-O2"],
    "pkg_config": "libpq",
    "optional": true, "disabled_cflags": "-DNO_PG -lc" }
]
```

A placeholder's substitution is built from up to three parts — the categories
toy's [FFI-manifest analysis](https://github.com/OriPekelman/toy) named:

- **A. self-referential `.o`** (`source` → compiled, or an override) — the gem's
  own object; the gem knows its layout.
- **B. system libs** (`pkg_config`, with `pkg_config_fallback`) — resolved from
  `pkg-config --cflags --libs <name>` at the *consumer's* environment, not a
  hardcoded `-l` (portable across brew/apt). `libs` adds any static extras.
- **C. opt-out** (`optional` + `name` + `disabled_cflags`) — a consumer who
  doesn't use the module disables it; the placeholder gets `disabled_cflags`
  (e.g. `-DNO_PG`, which the `.c`'s `#ifdef` compiles to a stub) so a missing
  `libpq` never breaks an unrelated build.

(gemspec `metadata` is the tidier home, but `gem unpack` doesn't reliably yield a
loadable spec, whereas a shipped file is always there — hence the JSON file.)

## What `vendor` does with it

After placing `lib/` for a gem that has a `spinel-ext.json`, for each entry it
substitutes the placeholder in the *placed* Ruby with the parts above joined:

1. **A — `.o`**: a prebuilt override (below), else `cc <cflags> -c <gem>/<source>
   -o vendor/spinel/<gem>/<base>.o`.
2. **B — system libs**: `pkg-config --cflags --libs <pkg_config>`, else
   `pkg_config_fallback`, else *leave the placeholder* (the build fails loud —
   never silently drop a required system dep).
3. **C — opt-out**: if `optional` and the consumer disabled `name`, substitute
   `disabled_cflags` instead and skip A/B.

Then the consumer's `spinel app.rb` (which `require_relative`s
`vendor/spinel/deps`) links via the now-substituted `ffi_cflags`. No manual
post-vendor step; `sync_tep.rb` / `post_vendor_tep.rb` retire fully.

### Overrides

```sh
# Reuse a prebuilt .o instead of recompiling (skips cc):
spinel-compat vendor --ext @TEP_SPHTTP_O@=/abs/sphttp.o   # or SPINEL_EXT_TEP_SPHTTP_O=…
# Opt out of an optional module (-> its disabled_cflags):
spinel-compat vendor --no-ext pg                          # or SPINEL_EXT_DISABLE=pg,sqlite
```

## Worked example — tep → toy

- tep ships `spinel-ext.json` (above) — its `.c` are already in `lib/tep/` and the
  `ffi_cflags "@TEP_*@"` directives already exist; tep is the single source of
  truth for its own FFI shape.
- toy's `bundle lock` + `spinel-compat vendor` compiles `sphttp.o` etc., resolves
  `sqlite3`/`libpq` via pkg-config, and rewrites the placeholders. toy keeps **no**
  substitution code — both `sync_tep.rb` and `post_vendor_tep.rb` retire.
- A toy deploy that doesn't use Postgres: `vendor --no-ext pg`.

## Caveats

- **Host-specific `.o`.** `vendor` compiles for the build host (same as tep's
  per-host `.o` today); no cross-compilation. Keep `vendor/` gitignored.
- **The long-term fix is Spinel-side.** If Spinel const-folded
  `File.expand_path("sphttp.o", __dir__)` in top-level `ffi_cflags`, category A
  would need no placeholder/substitution at all. Tracked upstream (toy is filing
  the Spinel issue); until then this is the workaround.
- **Trust is unchanged.** This is placement/build wiring, not gating — a C-ext
  gem still probes `risky` and earns trust only through the `verified` rung.

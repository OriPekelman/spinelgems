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
  { "placeholder": "@TEP_SPHTTP_O@", "source": "lib/tep/sphttp.c", "cflags": ["-O2"] },
  { "placeholder": "@TEP_SQLITE_O@", "source": "lib/tep/tep_sqlite.c", "cflags": ["-O2"] },
  { "placeholder": "@TEP_PG_O@", "source": "lib/tep/tep_pg.c", "cflags": ["-O2"], "libs": ["-lpq"] }
]
```

(gemspec `metadata` is the tidier home, but `gem unpack` doesn't reliably yield a
loadable spec, whereas a shipped file is always there — hence the JSON file.)

## What `vendor` does with it

After placing `lib/` for a gem that has a `spinel-ext.json`, for each entry:

1. **Resolve the `.o`** — prefer a prebuilt one (env / flag override, below); else
   `cc <cflags> -c <gem>/<source> -o vendor/spinel/<gem>/<base>.o`.
2. **Substitute the placeholder** in the *placed* Ruby:
   `@TEP_SPHTTP_O@` → `<abs path to the vendored .o> <libs…>`.

Then the consumer's `spinel app.rb` (which `require_relative`s
`vendor/spinel/deps`) links the `.o` automatically via the now-substituted
`ffi_cflags`. No manual post-vendor step; `sync_tep.rb`'s substitution is
subsumed.

### Reusing a prebuilt `.o` (override)

The `.o` is a host-specific build artifact. To reuse one already built in the
sibling's checkout (what tep's `TEP_SPHTTP_O` does today) instead of
recompiling, allow an override keyed on the placeholder:

```sh
spinel-compat vendor --ext @TEP_SPHTTP_O@=/abs/sphttp.o
# or env:  SPINEL_EXT_TEP_SPHTTP_O=/abs/sphttp.o
```

When given, `vendor` skips the `cc -c` and substitutes that path directly.

## Worked example — tep → toy

- tep ships `spinel-ext.json` (the three entries above) — its `.c` are already
  in `lib/tep/`, and the `ffi_cflags "@TEP_*@"` directives already exist.
- toy's `bundle lock` + `spinel-compat vendor` then compiles `sphttp.o` etc. into
  `vendor/spinel/tep/` and rewrites the placeholders. toy keeps **no**
  substitution code — `sync_tep.rb` retires fully.

## Caveats

- **Host-specific `.o`.** `vendor` compiles for the build host (same as tep's
  per-host `.o` today); no cross-compilation. Keep `vendor/` gitignored.
- **System libs.** `pg` needs `-lpq` present at link (declared via `libs`); a
  missing system lib fails the link with a clear `cannot find -lpq`, as now.
- **Trust is unchanged.** This is placement/build wiring, not gating — a C-ext
  gem still probes `risky` (uncompilable-by-the-static-probe) and earns trust
  only through the `verified` rung.

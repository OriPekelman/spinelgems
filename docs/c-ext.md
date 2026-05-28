# C extensions in the vendor flow

**Status:** shipped + verified (vendor wiring + inference). The supplier-shipped
manifest is **optional**; the default path infers everything from what the gem
already has.

A gem with a **C extension** — tep's `sphttp` / `sqlite` / `pg` — ships `.c`
source and uses Spinel's `ffi_cflags "@PLACEHOLDER@"` directive in its Ruby.
Before this change, the consumer hand-rolled the placeholder substitution
(toy's `prep/sync_tep.rb`). Now `spinel-compat vendor` owns it — *and* infers
the wiring from what the gem already has, so adopting the convention requires
**zero coordination** with the gem author.

## How Spinel links a C extension (mechanism, verified)

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

**The constraint that forces a placeholder.** `ffi_cflags` takes a *string
literal* — Spinel doesn't evaluate `__dir__` or `ENV.fetch` there. So the `.o`
path can't be computed in the source; it has to be injected by build-time
substitution. matz/spinel#1011 (toy's const-fold ask) would obviate this
category entirely; until then, the substitution is real and `vendor` owns it.

## Two paths, one schema — consumer-side by default

The vendor tool reads a small JSON record per extension (`{name, placeholder,
source?, cflags?, pkg_config?, pkg_config_fallback?, optional?, disabled_cflags?}`).
There are two ways that record can reach `vendor`:

### Path A — inferred, consumer-side (the default)

`spinel-compat detect-ext GEM_DIR` scans the gem's `lib/**/*.rb` for
`ffi_cflags "@…@"` declarations, matches each to a nearby `.c` source, and
emits a draft `spinel-ext.json`. The gem author **does not need to know
`spinel-ext.json` exists, ship it, or change anything**. Auto-detection turns
existing markers (which a Spinel-targeting gem already has) into the wiring
`vendor` needs.

```sh
spinel-compat detect-ext ~/sites/tep
# → JSON to stdout: sphttp, pg .o, pg cflags sentinel, sqlite — all matched
#   from the ffi_cflags markers and the *.c files already in tep's lib/tep/.
```

Limitations of inference: `.o` placeholders (category A) match cleanly from the
markers + sibling `.c`. **`_CFLAGS`-shaped placeholders** (category B — system
libs) are detected but the `pkg_config` name and `disabled_cflags` are
decisions a human still makes; `detect-ext` emits them as `null` with a
stderr warning. The curated source / proxy can carry the filled-in version as
a **sidecar** so consumers don't each redo it.

### Path B — supplier-shipped (optional, faster, more explicit)

A gem author who wants to be explicit (or whose extensions don't fit the
inference heuristic) can simply ship `spinel-ext.json` at the gem root (in
`s.files`). `vendor` reads it directly, no inference step.

Same schema either way:

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

The three categories (toy's [FFI-manifest analysis](https://github.com/OriPekelman/toy)
named them):

- **A. self-referential `.o`** (`source` → compiled, or an override) — the
  gem's own object; the gem knows its layout. **Auto-inferred.**
- **B. system libs** (`pkg_config`, with `pkg_config_fallback`) — resolved from
  `pkg-config --cflags --libs <name>` at the *consumer's* environment, not a
  hardcoded `-l`. **Detected but not fully inferred** — `pkg_config` name is a
  human decision.
- **C. opt-out** (`optional` + `name` + `disabled_cflags`) — a consumer who
  doesn't use the module disables it; the placeholder gets `disabled_cflags`
  (e.g. `-DNO_PG`, which the `.c`'s `#ifdef` compiles to a stub) so a missing
  `libpq` never breaks an unrelated build. **Human decision.**

## What `vendor` does

After placing `lib/` for a gem that has *either* an inferred or a shipped
`spinel-ext.json` (CLI: `spinel-compat vendor --infer-ext` will infer if no
shipped manifest is found — same effect), for each entry it substitutes the
placeholder in the placed Ruby with the parts above joined:

1. **A — `.o`**: a prebuilt override (`--ext @P@=/abs/x.o`), else
   `cc <cflags> -c <gem>/<source> -o vendor/spinel/<gem>/<base>.o`.
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

## Why inference, not a new convention for gem authors

Pushing `spinel-ext.json` as a *required* file would be a de-facto standard
imposed on Spinel-targeting gem authors. Nobody asked us to do that, and
matz/spinel hasn't endorsed it. **Keeping the convention strictly consumer-side
keeps the coordination cost at zero**:

- A gem author writes Spinel-targeting code today the same way they did
  yesterday (`ffi_cflags "@…@"` + `.c` files).
- spinelgems (the consumer's tool) does the inference.
- If the author *wants* to ship the manifest later (faster vendor, more
  explicit pkg-config / opt-out values), they can. Optional. Reversible.

This is the same shape as the broader spinelgems posture: use what exists
(Gemfile, Bundler resolver, the `ffi_cflags` markers already in the source),
don't invent new file formats people have to learn.

## Worked example — tep → toy (today)

```sh
spinel-compat detect-ext ~/sites/tep
#  → 4 entries: sphttp.c, tep_pg.c, tep_sqlite.c, plus a @TEP_PG_CFLAGS@
#    sentinel (warns on stderr that pkg_config / disabled_cflags need filling).

# Either commit a polished spinel-ext.json based on that draft (a one-time
# editorial pass to set pkg_config: "libpq" and disabled_cflags) and ship it
# in tep; OR keep it consumer-side: the curated source / proxy carries the
# filled-in sidecar for served gems.

# Then on the consumer (toy):
bundle lock
spinel-compat vendor                # compiles sphttp.o etc., substitutes placeholders
spinel tep_demo/hello_api.rb        # links the .o via the now-substituted ffi_cflags
```

toy keeps **no** substitution code — both `sync_tep.rb` and
`post_vendor_tep.rb` retire.

## The proxy / curated-source angle

When the curated source serves a Spinel-aware C-ext gem whose author hasn't
shipped a manifest, the proxy can call `detect-ext` on its way out and bake
the result (with the human-decided pkg_config / opt-out values supplied
once) into the served `.gem` as a sidecar. Result: consumers of the curated
source get the wiring **automatically**, without ever touching the upstream
gem author. (Implementation deferred — current proxy is store-serving and
works fine without; the hook is small when we want it.)

## Caveats

- **Vanilla CRuby c-ext gems are out.** Gems that load a `.so` via `mkmf` /
  `require "<gem>/<gem>"` don't work under Spinel — Spinel doesn't `dlopen`.
  The survey marks them `rejected:c-extension`. That's a cost of AOT, not
  something spinelgems can paper over; the gem needs to be ported to use
  Spinel's `ffi_cflags`/`ffi_func` DSL (a real rewrite by the gem author or a
  separate Spinel-targeting fork).
- **Host-specific `.o`.** `vendor` compiles for the build host (same as tep's
  per-host `.o` today); no cross-compilation. Keep `vendor/` gitignored.
- **matz/spinel#1011** (const-fold `__dir__` in `ffi_cflags`) would obviate
  category-A placeholders entirely — gems would just reference their own `.o`
  relative to themselves. The manifest would shrink to pkg-config + opt-out.
- **Trust is unchanged.** This is placement/build wiring, not gating — a
  C-ext gem still probes `risky` and earns trust only through the `verified`
  rung (a behaviour smoke through the harness).

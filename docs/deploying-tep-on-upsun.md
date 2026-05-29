# Deploying a Spinel-compiled Tep app on Upsun

How spinelgems.org serves itself from a native binary that the
[Tep](https://github.com/OriPekelman/tep) framework compiles via the
[Spinel](https://github.com/matz/spinel) AOT Ruby compiler — built on Upsun's
x86_64 build container, no Rust, no CRuby at runtime. This is the dogfood arc:
the Spinel dependency-manager's own website is itself a Spinel program.

> Status: proven end-to-end on an Upsun branch environment (fr-3). Times and
> commands below are from real builds.

## The shape

- **Build time** (Upsun build hook, x86_64 Debian, network + toolchain available):
  build Spinel from source, build Tep's C helpers, translate+compile the app
  (`app/serve.rb`) into a ~400 KB binary, and bake a read-only SQLite catalog DB.
- **Run time** (read-only filesystem, `$PORT`): exec the binary. It serves the
  static tree (`public/`, assets, the Compact Index) and the dynamic catalog,
  querying the baked SQLite DB. No CRuby, no services.

## The build

```sh
make deps   # curl + untar the prebuilt prism gem's C sources into vendor/prism
make all    # cc compiles libprism + the runtime, then bootstraps the analyzer
            # and codegen (CRuby runs the bootstrap once; output is C, cc-compiled)
```

So the only build requirements are `cc`/`make`/`ar` (the Upsun ruby image's
`build-essential`), CRuby (for the one-time bootstrap), and `curl`/`tar`. The
cold build is the cost: **~846s (~14 min)** for Spinel. Cache it.

## Use `ruby:3.4`

Tep's translator (`bin/tep`) `require`s **prism**. Ruby 3.4 bundles prism;
ruby 3.3 would need the gem (a native build). Set `type: "ruby:3.4"` and prism
is just there (`prism 1.5.2` on the current image).

## The build hook (cached)

`$PLATFORM_CACHE_DIR` persists across builds of an environment, so key the
Spinel build by the pinned commit and the 14-min bootstrap runs **once**;
every later deploy logs `spinel cache hit` and only the fast app compile runs.

```yaml
applications:
  spinelgems:
    type: "ruby:3.4"
    source: { root: "/" }
    variables:
      env:
        SPINEL_PIN: "96b21e6…"   # the commit Tep is verified against (tep SPINEL_PIN)
    hooks:
      build: |
        set -e
        PIN="$SPINEL_PIN"
        CACHE="$PLATFORM_CACHE_DIR/spinel-$PIN"
        if [ ! -x "$CACHE/spinel" ]; then
          git clone --quiet https://github.com/matz/spinel.git "$CACHE"
          git -C "$CACHE" checkout --quiet "$PIN"
          make -C "$CACHE" deps && make -C "$CACHE" all   # ~14 min, once
        fi
        export SPINEL="$CACHE/spinel"

        TEPDIR="$PLATFORM_CACHE_DIR/tep"
        if [ -d "$TEPDIR/.git" ]; then git -C "$TEPDIR" pull --quiet || true
        else git clone --quiet https://github.com/OriPekelman/tep.git "$TEPDIR"; fi
        export TEP_SKIP_SPINEL_FRESH=1 TEP_SPINEL_DIR="$CACHE"
        make -C "$TEPDIR" helper            # builds sphttp.o / tep_sqlite.o / tep_pg.o

        ruby exe/spinel-compat build-site --out public          # static fallback
        ruby exe/spinel-compat build-db   --out public/catalog.db  # read-only catalog DB
        "$TEPDIR/bin/tep" build app/serve.rb -o serve_bin
```

Both `matz/spinel` and `OriPekelman/tep` are public, so the hook clones them
over HTTPS with no credentials. `make helper` needs `TEP_SKIP_SPINEL_FRESH=1`
(don't let Tep re-checkout Spinel) and `TEP_SPINEL_DIR`/`SPINEL` pointing at the
cached build.

## Read-only filesystem

Upsun deploy containers are read-only unless you declare `mounts`. The compiled
binary, `public/`, and the SQLite DB are all **baked at build time and served
read-only** — so `mounts: {}`. Two things to get right:

- The binary takes its port from **ARGV `-p $PORT`** (not an env var). Spinel
  *does* support `ENV[]`/`ARGV`; Tep's generated `main` parses `-p`/`-w`.
- The SQLite DB is opened for reading only. A pure `SELECT` on a clean DB writes
  no journal, so it works on the read-only FS without a mount. (Build it with
  `PRAGMA journal_mode=OFF`; never start a write transaction at runtime.)

```yaml
    web:
      commands:
        start: |
          if [ -x serve_bin ]; then exec ./serve_bin -p $PORT
          else exec ruby exe/spinel-compat server --public public --port $PORT; fi
      locations: { "/": { passthru: true } }
    mounts: {}
```

The `||` fallback keeps a CRuby/WEBrick path (serving the static `build-site`
output) as a safety net if the binary is ever missing.

## Branch environments are the test rig

Every Upsun branch is a fully isolated environment with its own build cache and
URL. Push a `spike/…` branch, `upsun environment:activate` it (branch envs start
inactive), and you get a throwaway copy of the whole stack to prove the build
without touching production. We proved the toolchain, the cache, the read-only
SQLite, and the dynamic catalog on a branch before promoting to `main`.

## Result

`serve_bin` (≈400 KB) serves the live, query-paginated catalog over the baked
SQLite DB — no more 90 MB static HTML, no per-verdict page split, the full
rejected set browsable. `ldd` shows it linking only stock `libssl`/`libsqlite3`/
`libcrypto`/`libc`, all present on the runtime image. CRuby appears exactly once
in the whole pipeline: the Spinel bootstrap. The site you're reading is the
compiler's own output.

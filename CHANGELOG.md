# Changelog

All notable changes to `bundler-spinel` are documented here. The format
follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the
project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **A gem's `sig/*.rbs` acts as the type root (spinelgems#13).** Spinel infers
  param types from call sites (whole-program, closed-world), so an *uncalled*
  public method widens to `int`/`poly` — the failure mode hand-written seed
  blocks exist to patch. `--rbs` was verified to re-pin uncalled methods' param,
  return, and ivar types, so the tooling now treats a shipped `sig/` tree as
  authoritative: `spinel-compat verify` auto-passes `--rbs <gem>/sig` when the
  gem ships signatures (`--rbs DIR` to override, `--no-rbs` to opt out), and
  records an `rbs:sig` provenance tag in the verdict reasons. `vendor` copies
  each gem's `sig/` alongside `lib/`, aggregates all of them under
  `<into>/sig/<gem>/`, and advertises the single `--rbs <into>/sig` root in
  `deps.rb` and the CLI output. A spinel-native gem (SpinelKit, the Tep
  batteries) ships one standard Ruby artifact — no seed soup, no manifest keys.

## [0.3.0] — 2026-06-08

### Added
- **`spinel-compat vendor` build-units (spinelgems#14).** `spinel-ext.json` now
  supports a `build` entry — a declared native build (`tool: cmake | make`, with
  `dir`, `args`, `targets`, `artifacts`, and `patches`) run **inside the
  consumer's vendor tree**, with link flags expanded relative to it (`{dir}` and
  cross-entry `{dir:NAME}`). This lets a heavy-native gem — toy's vendored ggml
  CMake build plus its tinynn shims — vendor **self-contained and relocatable**,
  the same end state tep's small per-`.c` shims already had. A
  `SPINEL_EXT_<PLACEHOLDER>` override substitutes prebuilt flags and skips the
  build. Declared `patches` apply with stack-level already-applied detection, so
  a `path:`-sourced dev checkout (already patched) vendors cleanly. Proven
  end-to-end: a consumer vendors toy, the archives build in-tree, a
  Spinel-compiled program links and runs, with zero absolute paths and survival
  across a project move. Strictly narrower than `extconf.rb` (no free-form
  shell; declared artifacts) — the Spinel analogue of a gemspec `extensions:`.
- **`spinel-compat vendor` handles transitive gem→gem dependencies
  (spinelgems#19).** Vendoring a gem that depends on another vendored gem now
  works: `deps.rb` is emitted in **topological order** (every gem's runtime
  dependencies load before it, via a DFS over `spec.dependencies` with a stable
  alphabetical tiebreak and a cycle guard) instead of the lockfile's alphabetical
  order, and it prepends each vendored gem's `lib` to `$LOAD_PATH` so a
  dependent's plain `require "<depgem>"` resolves under CRuby too. Spinel (no load
  path) ignores both and relies on the topo-ordered `require_relative`s, so the
  one `deps.rb` is correct under both runtimes — verified identical output on a
  two-gem fixture. Unblocks `tep` → `spinel_kit` (the new stdlib-surface gem)
  on the clean `gem "spinel_kit"` + vendor path.
- **`spinel-compat why <gem>` (spinelgems#12).** A legible "why doesn't this gem
  work (yet)?" report: a plain-English cause, a category (native C-ext / Spinel
  limitation / fixable compiler bug / dependency-blocked / metaprogramming), the
  concrete evidence (the CRuby-vs-Spinel diff, the unresolved calls, the missing
  require, the hard construct), and — most usefully — whether the verdict is
  **terminal** (needs an upstream port or compiler feature) or **fixable** (a
  tracked compiler bug that can graduate). Reads the dominant-rev ledger entry
  like the catalog; `--probe` / `--dir` explains a fresh live probe instead.

### Changed
- **`spinel-ext.json` wiring now warns on manifest drift.** A declared
  placeholder that matches no vendored `.rb` emits a loud warning at vendor time
  — replacing the per-gem "cflags canary" constants consumers maintained by hand.
- **Catalog/site rendering** advanced across several engine-rev reprobes (signals
  lead every verdict tier; the download floor is off by default; human
  attestations earn a verified rung; a load-bearing-gems roadmap page). These
  affect the rendered spinelgems.org catalog, not the plugin's gating behaviour.

## [0.2.1] — 2026-06-01

### Fixed
- **`init` scaffold tripped `mise`/`asdf` on the engine marker.** Version managers
  read the Gemfile's `ruby "3.3.0", engine: "spinel", …` and tried to activate
  `ruby@spinel-0.0.0` (missing) → fell back to a Ruby without `bundler-spinel`, so
  `bin/build` failed with `spinel-compat: command not found` (first-user report,
  tep#156). The scaffold now also writes a config-tier `.tool-versions` pinning the
  real CRuby (`ruby <RUBY_VERSION>`), which overrides the Gemfile parse so the
  manager activates the Ruby that has `spinel-compat`. Reproduced + verified the
  fix against `mise` in a container.

## [0.2.0] — 2026-06-01

### Added
- **`verify` self-localizes a miscompile.** When the differential smoke diverges
  (CRuby and Spinel both run but disagree on stdout), `verify` now runs the
  value-bisection harness (`spinel-dev tools/value-bisect/bisect.sh --json`) on
  the still-on-disk harness and, when it pins the first scalar local to part
  ways, appends a `localized:<file>:<line> <var> cruby=… spinel=…` reason. This
  upgrades a bare `diff:L2 cruby=… spinel=…` ("the outputs differ") into a line
  to look at ("`x` is wrong here"). Strictly best-effort and non-fatal: if the
  harness can't be found (it's a separate repo — override with `SPINEL_BISECT`,
  else probed next to the engine and at `~/sites/spinel-dev`) or can't attribute
  the divergence to a traced scalar, the verdict is returned unchanged.

### Changed
- **`init` scaffold uses the published tep gem.** Now that tep is on RubyGems
  (`tep 0.11.1`), the generated `Gemfile` emits plain `gem "tep", ">= 0.11.1"`
  instead of the `git:`-fallback comment. Docs (`README`, `docs/adoption.md`)
  updated to the published-gem form. spinelgems#10.
- **`init`'s `bin/build` made self-sufficient + correct.** A clean-room run
  showed the old `bundle install && ./bin/build` flow couldn't run: the
  `engine: spinel` marker makes `bundle install` refuse under CRuby (by design),
  and `bundle lock` + `vendor` place tep's *lib* but never install the `tep`
  *CLI*. `bin/build` now `gem install`s tep if absent, uses `bundle lock` (not
  install), exports `SPINEL` (so tep finds the provisioned engine), then
  provisions + vendors + compiles; the `init` next-steps reflect this.
  **The full onboarding now runs end-to-end** — validated in a clean `ruby:3.3`
  container: `gem install bundler-spinel` → `init` → `./bin/build` → `./app`
  serves a Spinel-compiled Tep app (needs `tep ≥ 0.11.1`, which builds its C
  helpers on demand). spinelgems#10.

## [0.1.1] — 2026-06-01

### Fixed
- **`init` scaffold produced an unlockable Gemfile.** It wrote the engine git SHA
  into `engine_version:`, which bundler parses as a Gem version requirement —
  `bundle lock` died with `Illformed requirement [...]`. The scaffold now writes a
  version-literal `engine_version: "0.0.0"` (advisory) and pins the real revision
  in a `SPINEL_PIN` file, which `install-engine` already reads. Caught by a
  clean-room `ruby:3.3` Docker run of the full onboarding flow.

## [0.1.0] — 2026-06-01

First non-prerelease. Installable without `--pre`. Closes the onboarding gap
(spinelgems#9): a newcomer can `gem install bundler-spinel` and go from nothing
to a compiled Spinel app without an out-of-band `git clone matz/spinel && make`.

### Added
- **`spinel-compat install-engine [REV]`** — provisions the Spinel compiler
  itself: fetch matz/spinel at a pinned revision (arg › `SPINEL_PIN` file ›
  default) → `make deps && make all` → cache under `~/.cache/spinel/<rev>/` →
  point a `current` symlink at it. Idempotent, offline-after-first-build;
  `--force` rebuilds. `Engine` now resolves that cache after `SPINEL_DIR` and
  before PATH, so a provisioned engine is found with zero further configuration.
- **`spinel-compat init [DIR]`** — scaffolds a minimal Spinel + Tep project
  (`Gemfile` with the engine marker + `gem "tep"`, a hello `app.rb`, a
  `bin/build` that runs `install-engine` + `vendor` + `tep build`). Onboarding
  becomes `bundle install && spinel-compat init && bin/build`.
- `spinel-compat verify --full`: force-requires every `lib/` file (no `autoload`
  masking, no `LoadError` rescue) so verification covers the gem's whole surface,
  not just the entrypoint. Ledger probe `verify-full`.
- **Composable signal badges** on the catalog: `👤 human` (version-pinned
  attestations), `✪ tests` (the gem's own suite passes under Spinel,
  `verify --tests`), and a surfaced `rubric` tag (*why* a non-verified gem isn't
  there yet). See `docs/verification-tiers.md`.
- `docs/verification-tiers.md`: the trust ladder, the full-surface bar, the
  badge model, and the matz/spinel bug pipeline.

### Changed
- **`verified` now means full-surface.** The catalog grants ★ only to gems with
  a `verify-full` match — an entrypoint-only/constant smoke no longer qualifies
  (it overstated usability; see the qdrant-ruby spike, spinelgems#4).
- `GemFetcher` honours `SPINEL_COMPAT_CACHE` to relocate the source cache off a
  tight root fs.

### Fixed
- `vendor`: a split `@MOD_O@` / `@MOD_CFLAGS@` C-extension pair now associates by
  module name, so the source compile gets the sibling's `pkg_config` include
  path (spinelgems#8 — tep pg → `libpq-fe.h`).

## [0.0.1.pre] — 2026-05-26

First pre-release. **Experimental** — the CLI surface, the verdict vocabulary,
and the ledger format may all change before `0.0.1`. Install with `--pre`.

### Added
- Initial public release: the Gemfile convention for Spinel projects, the
  `spinel-compat` CLI (`vendor`, `check`, `probe`, `verify`, `survey`,
  `serve`, `ledger`, `reprobe`), and the `spinel-lock` / `spinel-check`
  Bundler plugin commands.
- Forward-compatible, engine-rev-keyed compatibility ledger.
- Wholesale `survey` with a thread-safe ledger, a per-compile wall-clock
  timeout (`analyze-timeout` reject reason), and a ledger-based report.

[0.2.1]: https://github.com/OriPekelman/spinelgems/releases/tag/v0.2.1
[0.2.0]: https://github.com/OriPekelman/spinelgems/releases/tag/v0.2.0
[0.1.1]: https://github.com/OriPekelman/spinelgems/releases/tag/v0.1.1
[0.1.0]: https://github.com/OriPekelman/spinelgems/releases/tag/v0.1.0
[0.0.1.pre]: https://github.com/OriPekelman/spinelgems/releases/tag/v0.0.1.pre

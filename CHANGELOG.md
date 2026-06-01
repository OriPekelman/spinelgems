# Changelog

All notable changes to `bundler-spinel` are documented here. The format
follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the
project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[0.1.1]: https://github.com/OriPekelman/spinelgems/releases/tag/v0.1.1
[0.1.0]: https://github.com/OriPekelman/spinelgems/releases/tag/v0.1.0
[0.0.1.pre]: https://github.com/OriPekelman/spinelgems/releases/tag/v0.0.1.pre

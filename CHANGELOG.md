# Changelog

All notable changes to `bundler-spinel` are documented here. The format
follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the
project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `spinel-compat verify --full`: force-requires every `lib/` file (no `autoload`
  masking, no `LoadError` rescue) so verification covers the gem's whole surface,
  not just the entrypoint. Ledger probe `verify-full`.
- `docs/verification-tiers.md`: the trust ladder, the full-surface bar, the
  77→16 demotion audit, and the matz/spinel bug pipeline.

### Changed
- **`verified` now means full-surface.** The catalog grants ★ only to gems with
  a `verify-full` match — an entrypoint-only/constant smoke no longer qualifies
  (it overstated usability; see the qdrant-ruby spike, spinelgems#4). Catalog
  `verified` went 77 → 16.
- `GemFetcher` honours `SPINEL_COMPAT_CACHE` to relocate the source cache off a
  tight root fs.

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

[0.0.1.pre]: https://github.com/OriPekelman/spinelgems/releases/tag/v0.0.1.pre

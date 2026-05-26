# Changelog

All notable changes to `bundler-spinel` are documented here. The format
follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the
project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

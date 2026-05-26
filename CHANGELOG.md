# Changelog

All notable changes to `bundler-spinel` are documented here. The format
follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the
project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial public release: the Gemfile convention for Spinel projects, the
  `spinel-compat` CLI (`vendor`, `check`, `probe`, `verify`, `survey`,
  `serve`, `ledger`, `reprobe`), and the `spinel-lock` / `spinel-check`
  Bundler plugin commands.
- Forward-compatible, engine-rev-keyed compatibility ledger.
- Wholesale `survey` with a thread-safe ledger, a per-compile wall-clock
  timeout (`analyze-timeout` reject reason), and a ledger-based report.

[Unreleased]: https://github.com/OriPekelman/spinelgems/commits/main

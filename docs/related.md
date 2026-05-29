# Related projects (and a name clash)

> ⚠️ Two unrelated projects share the name **"Spinel"**. `bundler-spinel` targets
> **[matz/spinel](https://github.com/matz/spinel)** (Matz's Ruby→C AOT compiler).
> It has **no relationship** to **[Spinel Cooperative](https://github.com/spinel-coop)**
> (André Arko's group, creator of Bundler).

## `spinel-coop/rv` — complementary, not competing

[`spinel-coop/rv`](https://github.com/spinel-coop/rv) is Spinel Cooperative's
Rust-based unified replacement for `rvm` / `rbenv` / `bundler` / `rubygems`. It's
a different layer: it accelerates the *CRuby* toolchain (install rubies + lock +
install gems, fast). It's **compatible**, not competing — `rv` produces a standard
`Gemfile.lock`, so `spinel-compat vendor` / `check` work over its output
identically to Bundler's. Use `rv` for your everyday Ruby/Bundler workflow if you
like; spinelgems still gates the Spinel-target build on top.

## `rubocop_spinel` — complementary, author-time

[`rubocop_spinel`](https://github.com/gurgeous/rubocop_spinel) (gurgeous) is a
RuboCop extension whose cops flag Spinel-unsupported Ruby (`class << self`,
`Thread.new`, …) at **author time** — AST-based, tracked against Spinel by PR.

It's complementary: it lints *your own code as you write it*, while bundler-spinel
gates *dependencies* at resolution time and adds the differential `verified` rung
— which catches **silent miscompiles a static linter can't see** (a gem can lint
clean and still produce wrong output under Spinel; see [`../harness/`](../harness/README.md)).
Its AST-based cop set is also a cleaner static-risk signal than our regex scan, so
it's a candidate to *feed* the probe's static signal. Use both: `rubocop_spinel`
while authoring, bundler-spinel to gate + verify what you depend on.

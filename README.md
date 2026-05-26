# bundler-spinel

Resolution-time gem-compatibility gating for the [Spinel](https://github.com/matz/spinel)
Ruby AOT compiler.

Spinel compiles a whole Ruby program to native C — no gems, no eval, no
metaprogramming — and when it meets unsupported Ruby it *silently emits a no-op*
rather than failing. Bundler, meanwhile, can't gate on engine compatibility
(`bundle lock` ignores `engine: "spinel"`; there's no `required_ruby_engine`
gemspec field). So an incompatible dependency normally fails late — at compile
time, or never.

`bundler-spinel` makes it fail **at `bundle lock` time**, with feature-named
reasons, against a **forward-compatible** ledger keyed on the Spinel revision.
A gem rejected today is re-probed automatically when you upgrade Spinel.

See [ARCHITECTURE.md](ARCHITECTURE.md) for the model.

## Quick start

```sh
exe/spinel-compat engine                 # show detected compiler + engine rev
exe/spinel-compat probe rake              # probe one gem; record a verdict
exe/spinel-compat probe tep --dir ~/sites/tep   # probe a path:/git: sibling
exe/spinel-compat check Gemfile.lock      # gate a lockfile (exit 1 if rejected)
exe/spinel-compat ledger                  # dump recorded verdicts
exe/spinel-compat reprobe                 # re-probe known gems under current rev
```

Verdicts: `✓ clean` · `★ verified` · `~ risky` · `✗ rejected`.

```
$ exe/spinel-compat check Gemfile.lock
  ✗ rake  13.4.2  rejected — analyze-failed, risk:eval, risk:method_missing
————————————————————————————————————————————————
REJECTED under git:0adca86+dirty:
  ✗ rake 13.4.2 — analyze-failed
$ echo $?
1
```

## As a Bundler plugin

```sh
bundle plugin install bundler-spinel --git https://…   # or --path ~/sites/bundler-spinel
bundle spinel-lock      # `bundle lock`, then gate the result at resolution time
bundle spinel-check     # gate an existing Gemfile.lock
```

Declare the engine in your Gemfile so `bundle install` also guards (exit 18):

```ruby
ruby "3.3.0", engine: "spinel", engine_version: "0.0.0"
```

## Environment

- `SPINEL_DIR` — path to the Spinel checkout (default `~/spinel`; falls back to a `spinel` on `PATH`).
- `SPINEL_COMPAT_LEDGER` — ledger path (default `ledger/compat.jsonl`).

## Status

Working: probe engine, forward-compat ledger, `spinel-compat` CLI, lock-time
gate + Bundler plugin command, the `verified` differential harness, and the
curated source (`serve`, Bundler-resolvable). Designed (stub + ARCHITECTURE.md):
platform-variant opt-in. The upstream proposal + asks of Spinel are in
[RFC.md](RFC.md).

The compile probe is a **lower bound** — Spinel has no load path, so multi-file
plain-`require` gems under-probe, and silent miscompiles are invisible to it.
Trust `verified` (smoke runs identically under CRuby and Spinel), not `clean`,
for the curated source. The curated source gates a clean env (CI); the lock-time
gate is the backstop on dev machines (Bundler also resolves locally-installed
gems).

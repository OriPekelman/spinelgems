# RFC: Use a Gemfile for Spinel projects (for now)

**Status:** draft (for discussion)
**Author:** Ori Pekelman
**Prototype:** [`bundler-spinel`](./README.md) — working, see [ARCHITECTURE.md](./ARCHITECTURE.md)

## Summary

Spinel-compiled projects have no shared way to declare or exchange dependencies,
so each one vendors by hand. This RFC proposes a deliberately small, temporary
answer that requires **no new design**:

1. **Declare dependencies in a standard `Gemfile`.** Mark the project with
   `ruby "3.x", engine: "spinel", engine_version: "0.0.0"`. That's the whole
   convention. It buys a familiar manifest, `path:`/`git:` sources for sibling
   projects, and Bundler's resolver + lockfile — for free.

2. **A small Bundler plugin** ([`bundler-spinel`](./README.md)) that does two
   things: **(a) makes it work** — places resolved dependencies where Spinel can
   actually find them; and **(b) gates** — flags gems Spinel can't compile early,
   so the experience is nicer than a silent miscompile.

The point is to **postpone the big discussion**. Spinel isn't near a release, and
there's no expectation it adopts any particular dependency-management design. But
projects need *some* interop today — so let's borrow a format everyone knows and
revisit later, rather than design a package manager now.

## Motivation

Interop is already happening, ad-hoc. Roundhouse (a separate author's project)
vendors part of Tep; our own projects carry a mix of rsync'd copies and hand-
maintained concatenation. Every project reinvents "get this other code into a
shape Spinel will compile." A shared, boring convention removes that duplication
without anyone committing to a long-term model.

Two facts make a thin tool worthwhile (both verified — Bundler 2.7.2 / CRuby):

- **Bundler already does the right thing with the engine marker.** `bundle lock`
  ignores `engine: "spinel"` and resolves normally (exit 0); only `bundle
  install` fires the guard ("Your Ruby engine is ruby, but your Gemfile specified
  spinel", exit 18). So the convention costs nothing and fails loudly in the
  right place.

- **Spinel doesn't fail loudly on unsupported Ruby.** It prints
  `warning: … cannot resolve call to 'eval' … (emitting 0)` and degrades the call
  to a no-op, exiting **0**; some constructs (and silent miscompiles) warn not at
  all. So "it compiled" ≠ "it works" — which is why a little gating help is worth
  having.

## Proposal 1 — the Gemfile convention

A Spinel project's `Gemfile`:

```ruby
source "https://rubygems.org"
ruby "3.3.0", engine: "spinel", engine_version: "0.0.0"

gem "tep", git: "https://…/tep.git"   # sibling projects via path:/git:
gem "some_pure_ruby_lib"              # third-party, if it compiles
```

Nothing here is novel — that's the point. `bundle lock` produces a normal
lockfile; siblings resolve through `path:`/`git:` sources (replacing rsync /
manual vendoring); third-party gems resolve from rubygems.org. The engine marker
documents the target and guards `bundle install`.

## Proposal 2 — the Bundler plugin

### (a) Make it work — placement

Spinel has no load path (plain `require "x"` resolves only against
`<spinel>/lib`) and inlines `require_relative`. So a resolved dependency has to
be *placed* where Spinel will follow it. The plugin vendors each locked gem's
`lib/` into a project dir and generates a `require_relative` manifest:

```
spinel-compat vendor            # reads Gemfile.lock
# -> vendor/spinel/<gem>/lib/…  and  vendor/spinel/deps.rb
```

A Spinel program then just `require_relative "vendor/spinel/deps"`. This is the
reusable form of what projects already do by hand (concatenation scripts, partial
vendoring).

### (b) Gating — a nicer experience

Because Spinel silently no-ops unsupported Ruby, the plugin probes gems (compile
+ static scan, optionally a differential CRuby-vs-Spinel run) and flags ones that
won't work — at `bundle lock` time, with reasons that name the missing feature:

```
bundle spinel-lock     # bundle lock, then report incompatible gems
```

Verdicts are **forward-compatible**: each is keyed on the Spinel revision (Spinel
ships no version, so we key on the git rev / binary hash, scoped by platform).
Upgrade Spinel → re-probe → a gem rejected today clears the moment the feature it
needed lands. No hand-maintained blocklist.

Gating is advisory by design — placement and compatibility are different jobs.
The plugin makes the failure visible and early; it doesn't try to be a wall.

## Open questions (for discussion, not asks)

These are things we ran into, offered as discussion points — not feature
requests, and not assuming Spinel wants any of them:

- **Signalling unsupported constructs.** Today they're silent no-ops at exit 0.
  Would a non-zero exit or a structured (e.g. JSON) diagnostic — perhaps behind a
  `--check`/`--strict` flag — be in scope or interest? It's the difference
  between inferring compatibility from stderr and reading it from a contract.
- **A stable engine identity.** We key verdicts on a git rev / binary hash for
  now. If Spinel ever wanted to expose a version/rev, the ledger and the
  `engine_version:` marker could line up — but there's no rush.
- **Resolving `require` beyond `<spinel>/lib`.** A load-path notion would let
  multi-file gems and stdlib shims resolve (and would make probing more
  accurate). Possibly useful well beyond this tool; possibly out of scope.

None of these are needed for the convention or the plugin to be useful today.
They're just where the seams are, if there's ever appetite to smooth them.

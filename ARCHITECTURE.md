# bundler-spinel — architecture

Make Spinel gem-incompatibility fail **at `bundle lock` time**, not at compile
time (where Spinel may silently emit a no-op instead of an error) — and make
that verdict **forward-compatible**, so a gem rejected today flips to accepted
the moment a future Spinel learns the feature it needed.

## The problem it solves

Spinel is a whole-program Ruby→C AOT compiler with no gems, no eval, no
metaprogramming. Two facts make naive dependency management dangerous:

1. **Bundler can't gate compatibility.** There is no `required_ruby_engine`
   gemspec field; `required_ruby_version` is engine-blind; you can't fabricate a
   platform variant for a gem you don't publish. The Gemfile `engine: "spinel"`
   directive is a *post-resolution* check — `bundle lock` ignores it (exit 0);
   only `bundle install` fires the guard (exit 18). So resolution can't reject
   an incompatible gem.

2. **Spinel doesn't fail loudly.** On unsupported Ruby it prints
   `warning: ... cannot resolve call to 'eval' ... (emitting 0)` and degrades
   the call to a no-op, exiting 0. Worse, some constructs (`define_method`,
   silent miscompiles like local-var-name collapse / Int-0-as-nil) produce no
   warning at all. So "it compiled" ≠ "it works."

This tool moves the decision to resolution time and grounds it in actually
running Spinel over the gem source.

## The ledger — single source of truth

`ledger/compat.jsonl`, append-only, one line per **`(gem, version, engine_rev)`**:

```json
{"gem":"rake","version":"13.4.2","rev":"git:0adca86+dirty",
 "verdict":"rejected","reasons":["analyze-failed"],
 "risks":["eval","method_missing","needs:rbconfig"],"probe":"compile+scan","at":"…"}
```

**`engine_rev` is the forward-compat key.** Spinel ships no version string
(`spinel --version` prints usage; `git describe` is a bare SHA), so we key on the
git revision of the Spinel checkout, falling back to a binary content-hash.
Upgrade Spinel → new rev → cache miss → automatic re-probe. No hand-maintained
blocklist; a `rejected` verdict is always "rejected *as of this rev, because of
these named features*," never "rejected forever." `spinel-compat reprobe` sweeps
known gems under the current rev to surface what newly passes.

## The verdict ladder

Spinel's failure modes aren't exit codes, so one signal isn't enough:

| Verdict | Earned by | Trusted by |
|---|---|---|
| `rejected` | unsupported **call** (`cannot resolve call to 'X'` → `unresolved:X`), or `analyze failed` / non-zero exit | gate fails the lock |
| `risky` | compiles clean, but static scan found constructs Spinel degrades silently (`define_method`, `eval`, `send`, `method_missing`, C-ext…) | gate allows; `--strict` fails |
| `clean` | compiles clean, no risky constructs | gate allows |
| `verified` | `clean` **and** the gem's own tests pass through a Spinel-compiled harness | curated whitelist + platform badge |

Two probe signals feed this:

- **Compile signal** (`spinel -c` over the gem's lib entrypoints) — parses stderr.
  `cannot resolve call to 'X'` is the gold signal: precise and forward-compatible.
- **Static risk scan** — catches constructs that are silently degraded (no
  warning) or hidden behind dead-code elimination.

### Honest limitations (why `verified` must exist)

- **No load path.** Spinel resolves plain `require "x"` only against
  `<spinel>/lib`. A gem's internal `require "gem/part"` and its stdlib requires
  don't resolve, so the compile probe doesn't fully follow multi-file gems
  (recorded as `needs:X` notes, not rejections). The compile signal is a **lower
  bound** on problems. `require_relative`-based gems probe well; plain-`require`
  gems under-probe.
- **Silent miscompiles** (var-name collapse, Int-0-as-nil) emit no warning and
  exit 0. The static scan can't see them either.

So `clean` means "no problem *found cheaply*," not "correct." Only `verified` —
compiling the gem's test suite and running it — is trustworthy, which is exactly
why the curated whitelist and the platform badge require it.

## Three consumers, all views over the ledger

### 1. Lock-time gate — `bundle spinel-lock` (BUILT)
`bundle lock` (resolves, ignoring the engine directive), then `check` resolves a
verdict for every locked gem (ledger hit, or probe-on-miss) and exits non-zero on
any `rejected`. The headline: resolution-time failure with feature-named reasons.
Also the **backstop** for consumer #2's leak (below): it re-checks every gem in
the *resulting* lock against the ledger regardless of where it resolved from.

### 1b. The `verified` rung — `spinel-compat verify` (BUILT)
Differential testing: run a smoke program once under CRuby and once Spinel-
compiled, diff stdout. The only signal that catches Spinel's **silent
miscompiles** — they emit no warning and exit 0, so the cheap probe calls them
`clean`, but a differential run diverges. Proven: a method doing `h[k].nil? ? -1
: v` over a stored `0` is `clean` to the probe but caught as `rejected:miscompile`
by verify (`L2 cruby="-1" spinel="0"` — the Int-0-as-nil footgun). The smoke is
the unit of trust, so `verified` is opt-in and smoke-supplied.

### 2. Curated source / proxy — `spinel-compat serve` (BUILT, MVP)
A Compact Index source serving only vetted gems from a local store of .gem
artifacts (`--min verified|clean|risky`). Proven end-to-end: `bundle lock` against
it resolves a vetted gem (exit 0) and fails on an absent one (exit 7, "could not
find gem … in repository … or installed locally"). The "whitelist" is not a file:
it's the acceptable-verdict subset of the ledger at the pinned rev. `path:`/`git:`
siblings (`gem "tep", path: …`) are the degenerate one-gem curated source and
probe in place via `probe --dir`.

**Leak caveat (important):** Bundler *also* considers locally-installed gems
("…or installed locally"). In a polluted environment an unvetted-but-installed
gem can resolve and even be mis-attributed to the source. So the curated source
gates a **clean** environment (CI); pair it with consumer #1 as a backstop for
dev machines. Read-through filtering of upstream rubygems is a documented
extension; empirically the third-party ecosystem is ~all-rejected today, so the
local-store mode is what carries weight.

### 3. Platform-variant opt-in (designed — `platform.rb` stub)
The bridge from "our ledger says verified" to "stock Bundler selects it,"
reusing the same machinery JRuby uses with the `java` platform. A `verified` gem
is republished (to the curated source) under a `spinel` platform token — likely
`<cpu>-spinel-<engine_rev>` so the badge is rev-scoped — and Bundler's normal
platform resolution prefers it. Opt-in because earning the badge means someone
ran the gem's tests through a Spinel-compiled harness.

## Dogfooding — the curated source served by Tep

The MVP proxy is CRuby/WEBrick (fast to prove Bundler resolves against it). The
target is to serve the same Compact Index endpoints from **Tep** — the Sinatra-
flavoured framework that *itself compiles via Spinel*. Then the Spinel
dependency-manager's source is a Spinel program: the system vets its own
substrate. Tep already has the pieces (`sphttp` server, routing, an HTTP client
for upstream fetch); the open questions are Spinel support for the bits the proxy
needs — MD5/SHA256 (digest), and reading the JSONL ledger — which are themselves
good probe targets. Serving `/names`, `/versions`, `/info/<gem>`, `/gems/<file>`
is plain text + file bytes, well within Tep's range.

## Layout

```
lib/bundler/spinel/
  engine.rb        # locate compiler, derive forward-compat engine rev
  ledger.rb        # append-only JSONL verdict store, keyed on (gem,version,rev)
  gem_fetcher.rb   # gem fetch + unpack (source, not install), cached
  probe.rb         # compile signal + static risk scan -> verdict
  checker.rb       # Gemfile.lock -> per-gem verdict -> pass/fail gate
  cli.rb           # `spinel-compat` dispatcher
  command.rb       # Bundler plugin command (bundle spinel-lock / -check)
  proxy.rb         # STUB: curated source
  platform.rb      # STUB: platform-variant opt-in
exe/spinel-compat  # standalone CLI
plugins.rb         # Bundler plugin entry
ledger/compat.jsonl
```

# Adopting the Gemfile convention — and breaking a project into libraries

A practical guide for Spinel projects (toy, tep, …) to (1) manage dependencies
with the [Gemfile convention](../RFC.md) instead of hand-vendoring, and (2)
extract reusable libraries so a consumer can depend on *just the slice it needs*
rather than vendoring a whole project.

The flow below is proven end-to-end in [`harness/`](../harness/README.md):
`bundle lock` → `spinel-compat vendor` → a Spinel program `require_relative`s the
generated `vendor/spinel/deps` and compiles, identically to CRuby.

---

## Part 1 — Adopt the convention

### The Gemfile

```ruby
source "https://rubygems.org"
ruby "3.3.0", engine: "spinel", engine_version: "0.0.0"

gem "tep"                             # published on RubyGems
gem "some_unreleased_lib", git: "…"   # or a sibling via git:/path: (replaces rsync)
```

`bundle lock` resolves normally (it ignores the engine marker); the marker only
guards `bundle install` (exit 18 under CRuby). Then:

```sh
spinel-compat vendor                 # Gemfile.lock -> vendor/spinel/<gem>/lib + deps.rb
spinel-compat check Gemfile.lock     # gate: exit 1 if any locked gem is rejected
```

A Spinel entrypoint does `require_relative "vendor/spinel/deps"`.

### Five things to get right (learned the hard way)

1. **A framework gem keeps its dev Gemfile plain — no engine marker.** tep is a
   *supplier* (others depend on it); its host-side Gemfile (`rake`, `minitest`,
   `rbs`) is for testing under CRuby. Adding `engine: "spinel"` there would fire
   the `bundle install` guard and fight the dev workflow. Only a *Spinel
   application* that vendors deps uses the marker.

2. **Build-time deps must be `development`, not `runtime`, in the gemspec.**
   tep's `prism` (the translator's parser) is build-time only; if it's a runtime
   dep, a consumer's `bundle lock` drags a native gem into the lock and the gate
   rejects it. Move such deps to `add_development_dependency`.

3. **C extensions: `vendor` infers the wiring; gem authors ship nothing new.**
   A Spinel-targeting C-ext gem (tep's `sphttp`/`sqlite`/`pg`) already has what
   we need: `.c` files in `lib/`, and `ffi_cflags "@TEP_*@"` directives in its
   Ruby. `spinel-compat detect-ext GEM_DIR` reads those existing markers and
   emits a draft `spinel-ext.json`; `spinel-compat vendor` then compiles each
   `.c` to a `.o` under the vendored dir and substitutes the placeholder — so
   the gem links with no hand-rolled step (this subsumes toy's
   `prep/sync_tep.rb` substitution). Reuse a prebuilt `.o` with
   `--ext @TEP_SPHTTP_O@=/abs/x.o` (or `SPINEL_EXT_TEP_SPHTTP_O=…`). Opt out
   of an optional module with `--no-ext pg`. *Keeping the convention strictly
   consumer-side keeps the coordination cost with gem authors at zero* — they
   can ship `spinel-ext.json` natively later if they want, but never have to.
   See [c-ext.md](c-ext.md). (Vanilla CRuby c-ext gems that use `.so`/mkmf are
   out — Spinel can't `dlopen` — and the survey marks them `rejected:c-extension`.)

4. **Prefer `require_relative` inside a gem; avoid plain `require "gem/part"`.**
   Spinel has no load path — it follows `require_relative` (and inlines it) but
   not plain `require`. A gem whose internal files use `require_relative` is
   *vendorable and compilable*; one that does `require "gem/part"` under-resolves
   under Spinel. (This is also the difference between a gem that can earn
   `verified` and one that can't — see the harness.)

5. **Trust `verified`, not `clean` or `loaded`.** `clean` = compiles cheaply;
   `loaded` = a require-only differential run loads identically; only `verified`
   = a behaviour smoke matches CRuby. The harness found gems that load fine yet
   silently miscompile. The curated source serves `verified` only.

### Concretely

- **tep**: move `prism` → development in `tep.gemspec`; keep the dev Gemfile
  marker-free; it's consumed via `path:`/`git:`. (It's the supplier.)
- **toy**: add a `Gemfile` with `ruby "…", engine: "spinel", …` and
  `gem "tep", path: "../tep"`; `bundle lock` + `spinel-compat vendor` → the Tep
  apps switch from `require_relative "../tep_demo/_tep_lib/tep"` to
  `require_relative "vendor/spinel/deps"`, retiring `prep/sync_tep.rb` (keep the
  `.o` substitution, per #3).

---

## Part 2 — Break a project into libraries

Goal: a consumer like Roundhouse, which uses only a small surface of tep, should
depend on **that slice** as a gem — not vendor the whole framework.

### First, find the boundary (it's not the `require_relative` graph)

Two project shapes, two methods:

- **`require_relative`-structured (toy).** The graph *is* the coupling. Leaf
  modules and small clusters extract cleanly. In toy: `bpe` is a leaf;
  `tokenizer → gguf_kv` is a small cluster; `gguf_load → transformer/gpt2/tinynn`
  is the heavy core. → a `toy-tokenizer` gem (`bpe` + `tokenizer` + `gguf_kv`) is
  a clean cut others could use without the model/training stack.

- **Flat-namespace monolith (tep).** Every `lib/tep/*.rb` is loaded by
  `lib/tep.rb` and modules cross-reference within the shared `Tep` namespace —
  `require_relative` is *flat*, so it tells you nothing. Use **cross-reference
  analysis**: which modules reference which classes/constants. A cohesive cluster
  that never reaches into the others is a clean cut. Verified for tep's HTTP
  core (`server, router, handler, request, response, filter, streamer, parser,
  net, url, multipart`): it references none of `Auth/Session/Jwt/Broadcast/
  Presence/LiveView/Sqlite/Pg/Llm/Mcp/Job/Scheduler`. → a **`tep-http`** gem (that
  cluster + the `sphttp` C extension) is extractable; the auth / realtime / data
  / AI clusters layer on top.

### Then, extract it as a gem (using the convention)

1. New gem `tep-http`: its own `gemspec` + `lib/tep-http.rb` that
   `require_relative`s the cluster's files (internal requires → `require_relative`,
   per Part 1 #4). Carry the C extension (`sphttp.c`) with it.
2. tep itself depends on it: `gem "tep-http", path: "../tep-http"`, and re-exposes
   it (so existing `Tep::Server` users are unaffected).
3. **Roundhouse** drops the tep vendoring and adds `gem "tep-http", git: "…"` —
   `spinel-compat vendor` places only that slice. Smaller surface, real interop,
   no rsync.

### Caveats

- **Extract the whole cohesive cluster at once.** In a flat namespace you can't
  pull one file out in isolation — take the cluster + its small shared utilities
  (`json`, `logger`) together.
- **C-ext slices carry their `.c`/`.o`** and the build substitution (Part 1 #3).
- **Start with the cleanest cut** (`tep-http`, `toy-tokenizer`) and let each
  extracted gem become independently **`verified`** through the harness — that's
  also how the curated source gets real, small, trustworthy entries.

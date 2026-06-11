# Harvest #11 @ cb23cc6 — bug clusters (HOLD: no filing while upstream is quiet)

Batch: 200 top-download-ranked unsmoked `loaded` gems at cb23cc6
(engine `/srv/data/scratch/spinelgems-rp/spinel-frozen-cb23cc6`, run ledger
`ledger/harvest11.jsonl`, raw structured results
`harvest11-cb23cc6-workflow.json`). Outcomes: **39 verified · 27 miscompile ·
25 codegen · 83 loadpath-limit · 5 risky-smoke · 21 skipped.**

Filing is **on hold** (see `triage-cb23cc6.md` header / matz-quiet). Clusters
below feed the queue when upstream wakes; smokes for every miscompile/codegen
entry are kept under `harness/smoke/` as ready reproducers.

## Cluster 1 — `Array#include?(SomeClass)` emits `sp_box_int((sp_Class){..})` (×9, file-ready)

`ancestors.include?(StandardError)` and friends box the class operand with
`sp_box_int`, which takes `mrb_int` → C error. Members: a--, aslon_settings,
dev_environment, radiant-site_templates-extension, couch, ormdev,
high_water_mark, github_repo_statistics; variant: `any` (class compared with
`==` against int/char* — invalid C binary `==` on `sp_Class`).
One focused filing covers all nine. Smallest repro: `puts [1].class.ancestors.include?(Comparable)`-shaped.

## Cluster 2 — module singleton methods (`class << self` / `extend self`) unresolved or miscompiled (×10+)

The widest family this round; several distinct surfaces, possibly one root:

- **Calls don't resolve, emitting 0 → runtime `undefined method ... for
  class`**: ibotta_geohash (encode/decode), catptcha (puzzle_js),
  camel_snake_keys (all four entrypoints), gemify (**`extend self`** variant),
  link_url (class method calling sibling class method via `self.tlds`).
- **`'self' undeclared` in emitted `_cls_` functions when the singleton method
  touches class-level ivars**: inform (@level), ni-logger (@options),
  arbiter (@message_table; plus `sp_RbVal _t = 0` invalid initializer).
- **Behaviour faces of the same blind spot**: frosty_meadow (`class << self`
  `to_s` override silently ignored — default Module#to_s wins),
  fresh_connection + `a` (`respond_to?` → false for singleton-defined
  methods), seapig-server (`constants.empty?` false on a bare module).

Related to the pooled `_block`/`_benv` private_class_method variant from
harvest #10 and to #1386's reopened-builtin `self` — but these are plain
modules, not reopened builtins. Candidate umbrella filing: "module
singleton-class methods: resolution + self-binding + reflection".

## Cluster 3 — string-typed ivar / attr_reader returns 0 (×3)

loc (attr_reader :lat/:lng after `new(lat,lng)` → 0), libring (ctor-arg string
→ 0), castanet (bool attr + `alias_method :ok?` inside `tap` → 0). Typed-ivar
init/reader codegen.

## Cluster 4 — frozen?/literal semantics on module constants (×2)

singem + gitfinger: `VERSION.frozen?` → true under Spinel, false under CRuby
(no `frozen_string_literal` comment in source). Spec-level question (matz may
declare frozen-by-default in-scope-by-design — check before filing; candidate
for the out-of-scope list instead).

## Cluster 5 — reflection oddities (×3)

require_relative gem (`respond_to?(:require_relative, true)` → false),
mtracker (`instance_methods` includes privates), hrk (`defined?(Hrk)` → nil
while `.name`/`is_a?` work).

## Singles worth keeping (one-line repros in workflow.json)

- **transdeps**: Ruby `=~`-named method emitted as C identifier
  `..._eq~` — tilde in a C name, parse error. Trivial fix, fun filing.
- **bumpy**: `gsub` block using `$1` returns "" (capture-global in block —
  adjacent to the #1009 regex-escape family).
- **rviz**: `Hash#each |k,v|` destructuring in a module-included instance
  method yields raw pointers (prints object-id-like numbers).
- **rack-standards**: proc-based Rack app returns garbage pointer for int
  status; localizer pinned `env` typed `i:0` at the call site (self-localize
  worked! — spinelgems#11 payoff).
- **satoshi-unit**: symbol-keyed Hash constant lookup returns wrong member's
  value.
- **tvd-ssh**: `File.read(File.expand_path(__FILE__-relative))` → "" (pairs
  with envme's `File.expand_path` boxed via `sp_box_int`).
- **rot13**: `Range#map` over `('a'..'z')` unresolved (known builtin-gap
  genre, goes on the gap-list with the cb23cc6 triage cluster 8).
- **ilesspainfulclient-cucumber**: `String#length` on interpolation with ANSI
  escapes → 0.
- **timecapsule**: `String#delete(',')` returns a number.
- **active-record-without-callbacks**: `puts proc{true}.call` prints `1`.
- **retry-this**: `inject` block-param propagation broken (first attempt sees 0).
- **rack-commonlogger**: constant defined via `require_relative` inside class
  body unresolved at runtime (`uninitialized constant Rack_CommonLogger::VERSION`).

## Promotion

The 39 behaviour-verified gems were re-run `--full` for the ★ bar; see the
catalog commit for the post-promotion count (full-surface drops are expected
— that's the bar doing its job).

# Triage: the 13 lost-★ behaviour build-errors at 12b757f0

Every gem that was ★verified at 42adf886 and behaviour-rejected at 12b757f0,
re-run with raw stderr on BOTH 65fb6d2d and 12b757f0 for attribution.
(14th sibling spinel_kit was a harness/spin-shape artifact, handled at
promotion.)

## New regressions in the 65fb6d2d → 12b757f0 window (3) — filable

| gem | shape | repro |
|---|---|---|
| dir | reopening builtin `class Dir` to add a constant emits a user `sp_Dir` struct colliding with the builtin's C type (`conflicting types for 'sp_Dir'`) | `dir-reopen-builtin-struct-collision.rb` (4 lines; 65fb6d2d clean) |
| underscore-rails | `defined?(::Rails)` inside `module Underscore::Rails` IGNORES the top-level `::` anchor and finds the nested module — guard truthy where CRuby says false, gem then dies at runtime (`uninitialized constant Version`). #3258's qualified-constant family, distinct bug | `defined-toplevel-anchor-ignored.rb` (9 lines; wrong *runtime* behavior, not a refusal) |
| yarn_lock_parser | `CONST_HASH.keys.sort.map(&:to_s)` on a frozen symbol-hash constant collapses to ty22 (`unsupported call: map`) when the class's singleton carries a compound untyped method body. spinel-reduce fixpoint at 25 lines — every single-construct removal restores compilation (compound inference degradation, mirror-ceiling family) | `hash-keys-collapse-compound.rb` |

## Pre-existing (fail identically at 65fb6d2d) — ★ was last earned at 42adf886 (9)

- **dynamics** — `respond_to?(:m)` keeps an uncalled method alive; its param
  widens to int; `Dir.mkdir(param)` → C error `incompatible type for
  sp_dir_mkdir`. 6-line repro, both engines. The exact widening the `--rbs`
  seeding exists to patch; filable as codegen-on-ordinary-Ruby if desired.
- **safe_timeout** (`Process.wait`), **tinnef** (`IO.popen`),
  **codeclimate_batch** (`Kernel#gem`), **hunger_unifonic** (`Kernel#URI`),
  **ruby_version** (`Gem::Version`-ish `.parse` on ty46),
  **IcentrisJira** (net/http `basic_auth`), **hello** (own `name?` unresolved),
  **sd_notify** (global variable read, line 84) — all now refuse-on-unresolved
  where 42adf886 compiled them. Same silent→loud strictness family as #1605 /
  the $: preamble (#3284); not individually filable as bugs.

## Conclusion

Of 13, only **3 are true 12b757f0-window regressions** (dir /
underscore-rails / yarn_lock_parser) — all three reduced to committed repros,
unfiled. underscore-rails is the sharpest: silently WRONG runtime behavior
(a `defined?` guard flips), not a loud refusal. 9 are older strictness we
only now re-measured (harness last ran at 42adf886), 1 was tooling
(spinel_kit).

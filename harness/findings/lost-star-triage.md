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
FILED 2026-07-24 as #3321 / #3320 / #3322 (re-verified still-failing at
76cfd099 first). underscore-rails is the sharpest: silently WRONG runtime behavior
(a `defined?` guard flips), not a loud refusal. 9 are older strictness we
only now re-measured (harness last ran at 42adf886), 1 was tooling
(spinel_kit).

## Upstream velocity note (2026-07-24)

All three of the PREVIOUS cycle's filings closed within ~24-48h of filing and
are verified fixed at 76cfd099: #3258 (68fd45da), #3259, #3284 (10108a62 —
our design ask implemented verbatim: load-path manipulation in statement
position warns and no-ops). With #3258+#3259 fixed, the addressable mirror's
full-surface un-pause is UNBLOCKED.

## Resolution (2026-07-25, engine 681b08ae)

#3320/#3321/#3322 all closed same-day (13ab61b1 / 79fdd68e / hash-variant
work). All three repros verified fixed at 681b08ae; dir + yarn_lock_parser
re-earn ★ outright. underscore-rails surfaced one residual — defined? on a
hoisted conditionally-defined class answers statically true — which upstream
DOCUMENTS as deliberate (docs/limitations.md, the #3274 wave). Smoke adjusted
(rule extended: don't assert defined? on conditionally-defined constants);
★ re-earned. All three land in the catalog at the next baseline.

## c51b0a1c cycle: the 73 regressions sampled (2026-07-27)

72 of 73 are `analyze-failed`; the 73rd is our own too_heavy_gem
static-scan-truncated downgrade. 15 sampled with raw stderr: every one is a
loud compile-time refusal on a genuinely dynamic construct (`self.new` with
an unresolved arg, untyped ivar in a boolean condition — the new
"unsupported condition (non-bool)" diagnostic — `instance_variable_set`
reflection, module-name/expression strictness). Zero segfaults, zero C
errors, no shared cluster. Same silent→loud family as #1605/the $:-wave;
nothing filable. DISPOSITION: accepted strictness, no follow-up.

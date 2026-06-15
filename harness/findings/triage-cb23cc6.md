# Failure-cluster triage @ matz/spinel cb23cc6

> **SUPERSEDED 2026-06-15 — HOLD lifted, most of this queue is FIXED.** matz
> shipped 636 commits (cb23cc6→b60fbd7). Status of the filing queue below,
> confirmed against the b60fbd7 build/reprobe (see
> [`b60fbd7-absorption.md`](b60fbd7-absorption.md)):
> - **Filing A** (19-gem parse regression) → FIXED by master `33873b1`
>   (computed-require mis-parse). *Caveat:* unresolvable plain `require` now
>   hard-fails the compile — a new, separate effect we absorbed probe-side and
>   that is itself an upstream filing candidate (see absorption doc).
> - **Filing B** (raise-fallback `sp_box_int((sp_raise…))`, ~110 gems) →
>   **FIXED at b60fbd7** (re-verified 2026-06-15: mail_address/source_finder/
>   twilito now `clean`; 0 raise-fallback-box hits in a 10-gem sample). The
>   inference/box rewrite subsumed it — do NOT file.
> - **Filing C** (initialize-yield `_block`) → covered by #1387-area fixes
>   (`c0673d9`); retest.
> - **Filing D** (`Foo::Bar`→`Foo_Bar` const rendering) → retest at b60fbd7.
> - **Filing E** / #1386 evidence → #1386 CLOSED + fixed (`827e4de`); moot.
> - harvest-11 box_int `Array#include?(Class)` ×9 → FIXED (`4766c81`);
>   transdeps `=~` → FIXED (`6815e92`); frozen-literal → by design (`2f09340`,
>   add to out-of-scope, don't file).
>
> The original HOLD note (now historical) follows.
>
> **HOLD — do not file yet.** Upstream is quiet (no commits past cb23cc6, no
> issue activity since 06-08; matz appears to be away). This is the ranked
> filing queue for when activity resumes. Filed-issue cross-refs verified
> against the open set on 2026-06-11.

Data: `survey-cb23cc6/compat.jsonl` (193,933 records over the 189,750-gem
corpus; the +4,183 records vs `survey-95557f5/` are verify/verify-full stage
records, not new gems).

## Verdict-mix delta (cb23cc6 vs 95557f5)

| verdict | 95557f5 | cb23cc6 | delta |
|---|---|---|---|
| verified | — | 158 | NEW tier in survey |
| loaded | — | 2,411 | NEW tier in survey |
| clean | 55,568 | 57,596 | +2,028 |
| risky | 23,926 | 29,797 | +5,871 |
| rejected | 110,256 | 103,971 | −6,285 |

Headline is #1360's landing: 8,833 hard-rejects (`hard:Thread.new` 5,979 /
`hard:Mutex.new` 2,821 / `hard:Mutex_m` 33) demoted to risk markers.
`analyze-failed` halved (8,668 → 4,363). **Counter-current**: per-method
`unresolved:*` rejections rose on an identical corpus — `unresolved:new`
17,137→20,341, `dup` 1,577→1,920, `uniq` 943→1,134, `strftime` 645→759.
A real static-resolution regression underneath the net win (see Regressions).

## Top clusters

| # | count | signature | representative | matched issue |
|---|---|---|---|---|
| 1 | 30,719 | `no-entrypoint` (static) | — | corpus shape, not fileable |
| 2 | 8,178 first-reason (20,341 any) | `unresolved:new` (static) | abstraction, duck_enforcer | partly #1386-adjacent regression |
| 3 | 4,363 | `analyze-failed` (spinel_analyze crash) | 189seg | improved 2×; residue opaque |
| 4 | 4,084 | `unresolved:require` (computed require) | — | #1383 |
| 5 | 2,666 | `c-extension` | — | by design |
| 6 | 412 | verify `rubric:codegen`, sub-clusters below | — | mixed |
| 6a | 70 | `'self' undeclared` — reopened builtins | to-bool, encoding-kawai, in_array | #1386 |
| 6b | ~110 | raise-fallback `(mrb_int)0` poisons context type | mail_address, source_finder, twilito | **NEW → filing B** |
| 6c | 31 | `'_block'`/`'_benv'` undeclared — yield in top-level defs / initialize-via-new | try-for, rakeup | adjacent #1387 → filing C |
| 7 | 349 | `analyze-oom` blacklist | CalculatorApimatic | #1302 |
| 8 | 159 | verify `rubric:unsupported` — missing builtin container methods (`join` poly_array, `pack` str_array, …) | mail_address, advanced_math | unfiled gap-list; low individual value |
| 9 | 99 | verify `rubric:miscompile` — heterogeneous divergence | ae_network_connection_exception | const-name sub-cluster → filing D |
| 10 | 56 (25 gems) | verify `rubric:build-error` — Spinel parse errors on CRuby-valid Ruby | parse-cron | **NEW → filing A (regression)** |

No #1369 (FiberSlot), #1351 (hang), or #1373 (circular require) signatures in
this ledger. Out-of-scope check: nothing here touches #1307 (alias-special-
globals); direct `$&`/`$'` reads remain in-scope per its closing comment.

## Regressions (highest filing value)

**True same-probe regressions — 28 gems** `loaded` at earlier revs
(8d88ebe/a03bb49/8adbd7b/2183a92, entrypoint-only `verify`) → `rejected` @
cb23cc6 under the same probe:

- **19 parse-error regressions**: parse-cron, expression_parser,
  open_uri_redirections, churn, ey_config, ansi-to-html, bind9mgr, hz2py,
  darian, unicode_japanese, redrum, rspayd, ruby-sox, ruby-yui, tm_helper,
  bitcoin-cigs, distinguished_name, minitest-implicit-subject,
  piwik_analytics — all now `Parse errors in '__spinel_verify.rb'`; compiled
  and ran at 8d88ebe.
- **9 `'self' undeclared` regressions** (reopened-builtin core-ext gems):
  to-bool, vine, encoding-kawai, andsqr, in_array, lightcore, grab,
  to_sentence_exclusive, escalate — covered by #1386.

**Static-stage regressions — 267 gems** `clean`@95557f5 → `rejected`@cb23cc6,
dominated by core-ext gems whose calls on `self` inside reopened builtins no
longer resolve (array_is_uniq: `unresolved:length,uniq`; date_night:
`unresolved:strftime` via module include into reopened `Time`). The static-
analyzer face of #1386 — the `include`-into-builtin variant may be outside its
current repro.

(Context: 2,295 gems improved rejected→clean; 588 previously loaded/verified
gems rejected by the stricter `verify-full` probe are probe-strictness
artifacts, not compiler regressions.)

## Filing queue (when upstream wakes)

- **A. Parser regression @cb23cc6** — 19 gems parsed at 8d88ebe now fail.
  Representative parse-cron 0.1.4. Run ddmin-for-parse-errors to pin the
  construct per gem before filing. Note commit 13a861f is in the regression
  window; 6 members read `$&`/`$'` directly (in-scope per #1307 closure).
- **B. raise-fallback `(mrb_int)0` poisons surrounding C type** (~110
  records). Evidence (mail_address 1.3.1): `_t105 = sp_box_int(({
  sp_raise_cls("FrozenError", …); lv_line; }));` → `incompatible type for
  argument 1 of 'sp_box_int'` (lv_line is `const char *`). Converts every
  graceful unsupported-call into a hard build failure; one fix ≈ 50–110 gems.
- **C. `yield self if block_given?` in `initialize` (block through `.new`) and
  top-level defs → `'_block'`/`'_benv'` undeclared** (31 records). rakeup
  1.2.0 server_task.rb:35; try-for 0.1.0. Two surfaces distinct from #1387's
  class-method case; at minimum comment there with both reproducers.
- **D. Constant-path rendering miscompile**: `Foo::Bar` prints as `Foo_Bar`
  (ae_network_connection_exception 1.10.0,
  `diff:L3 cruby="…::ConnectionNotEstablished" spinel="…_ConnectionNotEstablished"`).
  Related misclassifications: knife-cloudformation prints `Integer` for
  `Gem::Version`; minitest-spec-context prints `0` for `Minitest::Spec`.
- **E. Evidence-append to #1386**: the 267 clean→rejected static regressions +
  `unresolved:dup/uniq/strftime/new` corpus rises quantify the blast radius
  (~270+ static + 70 codegen); include the date_night include-variant.

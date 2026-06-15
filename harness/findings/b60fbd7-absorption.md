# Absorbing spinel master b60fbd7 — the 636-commit wave

Built/froze matz/spinel master **b60fbd7** (636 commits past cb23cc6, all Matz)
on 2026-06-15, reprobed the 189k corpus, and harvested behaviour. This is the
single largest catalog movement in the project's history and the end of the
2026-06-08→15 quiet period.

## 1. Corpus verdict-mix delta (static probe)

| verdict | cb23cc6 (raw) | b60fbd7 raw | b60fbd7 require-fixed (committed) |
|---|--:|--:|--:|
| clean | 57,596 | 79,663 | 79,664 |
| risky | 25,415 | 42,672 | 52,388 |
| rejected | 106,739 | 67,411 | 57,698 |

Static reprobe over 189,750 gems. The require-fix re-probe of the 33,148
`analyze-failed` gems moved **9,716** of them `rejected → risky [load-path:require]`
(the other 23,432 are real codegen failures). **Net: −49,041 rejected vs
cb23cc6 (−46%), +22,068 clean.** Best-verdict (site, sticky-applied) at
b60fbd7: 79,470 clean · 52,386 risky · 57,758 rejected · **136 ★ · 0 loaded**
(loaded tier pending a b60fbd7 behaviour refresh — see §9).

**Headline: ~49k gems left `rejected` (−46%), +22k became `clean`.** The driver
is the type-inference rewrite — the entire `unresolved:<method>` reject family
(~60k records at cb23cc6: `unresolved:new` 56.6k, `[]` 2.3k, `<=>`, `===`, …)
**dropped to ~zero**. The 636 commits resolve the calls the static analyzer
previously couldn't.

The require-fix column reflects the probe correction in §3 (final numbers
pending the analyze-failed re-probe; ~31% of the sampled analyze-failed set
reclassifies to `risky`).

## 2. The `analyze-failed` surge (3,967 → 33,147)

The flip side of the win: `analyze-failed` rejects rose ~8×. Transition
analysis (joining cb23cc6↔b60fbd7 by gem):

- **26,640** were already `rejected` at cb23cc6 (mostly `unresolved:*`) — the
  analyzer now gets *further* (resolves the call) then hits a codegen error.
  Lateral, not a regression.
- **3,463** stayed `analyze-failed`.
- **3,045** regressed from `clean`/`risky` → `analyze-failed`. The true
  regressions.

Root-causing the 3,045 (and a chunk of the rest): of a 50-gem analyze-failed
sample, **~24% fail *only* because a plain `require "gem/sub"` is now
unresolvable-and-fatal** (see §3); the other ~73% are real codegen errors —
many lateral (already-rejected gems failing later). A second, smaller real
contributor is per-gem analyzer **segfaults** (one observed live during the
reprobe; #1302's uncapped-memory analyzer is now crashier).

## 3. New upstream behavior absorbed: unresolvable `require` hard-fails

Since matz/spinel's #1383 fix, an unresolvable plain `require "x"` is emitted as
an unsupported `CallNode \`require\`` and **`spinel -c` exits non-zero** —
where cb23cc6 warned and continued (exit 0). Because `require "gem/version"` is
near-universal, this alone spuriously rejected thousands of clean gems.

**Absorbed probe-side** (`d48856b`): a compile that fails *solely* on an
unresolvable require (no `HARD_COMPILE_ERROR`, no unresolved call) → classified
`risky [load-path:require]`, the documented no-load-path limitation a real
Spinel project resolves by vendoring. Real codegen errors still reject. The
33k analyze-failed subset was re-probed with the fix and merged into the
b60fbd7 catalog.

**Upstream filing candidate:** unresolvable `require` should warn-and-continue
(exit 0) or offer a flag — hard-failing the whole compile on a require Spinel
*by design* can't follow (no load path) breaks the contract the vendoring
story depends on. Freshly confirmed at b60fbd7; minimal repro:
filed as **matz/spinel#1400** (`require` inside an `if` branch hard-fails; top-level warns+continues).

## 4. Our closed issues — confirmed at b60fbd7

Spot-verified fixed (minimal reproducers green on the new engine): **#1386**
(reopened-builtin `return self`, was ~270 static + 70 codegen), **#1382/#1394**
(hash-block pointer-as-int), **#1387** (class-method yield), the harvest-11
`Array#include?(Class)` `sp_box_int` cluster (×9), transdeps `=~` C-identifier.
Closed upstream + fix located: **#1373** (minitest, `705aa2e`), **#1383**
(computed require, `33873b1`), **#1369** boot crash + **#1384** SIGTERM
(`1ed28fa`) — **tep serve path unblocked**.

Flags (closed upstream but verify against the filed repro):
- **#1379** Hash.new{} default block self-capture — our minimal repro still
  miscompiles to empty output at b60fbd7. Confirm vs the filed repro; may need
  a reopen/comment.
- **#1383** — closed, but see §3: the *new* hard-fail behavior is a fresh
  concern even though the original mis-parse is fixed.

## 5. New blocker found: method call on a constant alias

`A = M::N; A.foo(x)` is unsupported; direct `M::N.foo(x)` works. Gates
**spinel_kit** graduation (its smoke does `J = SpinelKit::Json; puts J.escape`).
Filed upstream: **matz/spinel#1399**. spinelkit#1 updated with the
finding + the expand-the-alias workaround.

## 6. Still open / not fixed
- **#1392** (Float→Integer map aliases FloatArray as IntArray, SIGSEGV) — the
  `b60fbd7` FFI-boundary commit is adjacent but doesn't cover the map path.
- **#1302** (analyzer 100+GB OOM) — not fixed; `671c572` made analysis 5.8×
  faster but uncapped memory; the new analyzer also segfaults on some gems.
- **#1351** (flutie hang), **#1367** (layout-sensitive inference) — reprobe.
- **triage filing B** (raise-fallback `sp_box_int((sp_raise…))`, ~110 gems) —
  **FIXED at b60fbd7** (re-verified: mail_address/source_finder/twilito clean;
  0 hits in a 10-gem sample). Subsumed by the inference/box rewrite; not filed.

## 7. Leverage (new capabilities)
- **RBS in/out** (`dcc682f` `--rbs` seeds, `4f5b371` `--emit-rbs`, `2b9a7be`
  `--emit-types`) — direct fuel for spinelgems#13 (we already ship sig as a
  type root; now we can both feed seeds *and* harvest inferred RBS).
- **`--emit-symbol-map`** (`a9959ea`) → serves #1334.
- **`#line` directives** (`0189fe6`) → cc errors map to Ruby source; improves
  our codegen-failure triage (#1338).
- **Value-type objects** (stack-allocated immutable classes) — perf; may shift
  object-heavy gem verdicts in future harvests.

## 8. Regression-watch (areas touched, verify in behaviour)
String-literals-always-frozen (`2f09340`; in-place literal mutation now
raises), operator-method C-symbol mangling change (`6815e92`), Array#dup/#clone
copy-not-alias (`d7b5450`), GC-rooting churn, aggressive poly re-narrowing.
Run a harvest pass watching for new behaviour diffs on these.

## 9. Tech-debt status
- **Removed/absorbed:** the require-hard-fail misclassification (probe fix,
  §3); the "matz is quiet" HOLD (memory retired); the cb23cc6 triage queue
  (mostly fixed — doc superseded).
- **probe.rb static filters:** reviewed — already correctly conservative (only
  TracePoint/set_trace_func hard-reject; Mutex/Thread already demoted; the rest
  downgrade-only). Nothing stale to remove.
- **New debt:** the analyzer-segfault subset (a slice of analyze-failed that
  isn't require-only and isn't a clean codegen error) — characterize and feed
  #1302. The deploy pin pair (spinel+tep) needs bumping to b60fbd7 (tep#214).
- **Sibling absorption filed:** spinelkit#1 (const-alias), tep#214 (serve
  retest + pin + seed-soup), toy#95 (gate re-validation + eval recheck),
  spinel-dev#26 (fork-branch retirement).


## ★ regressions at b60fbd7 — verified@cb23cc6, NOT verified@b60fbd7 (re-verify-full)

43 of 175 lost ★ (132 survived). ~34 genuine (12 miscompile + 22 codegen);
9 are the require-only artifact in --full (load-path limit, not a true regression).
Each has a kept smoke under harness/smoke/ as a ready reproducer. Premium
upstream material now that matz is active — likely the frozen-literal (2f09340),
Array#dup-copy (d7b5450), operator-mangle (6815e92), poly re-narrowing changes.

### filed upstream
- **matz/spinel#1408** — `Module/Class#respond_to?` returns false for inherited builtins (`:name`/`:new`/`:instance_methods`); confirmed cb23cc6 true → b60fbd7 false. Covers the true→false cluster: bundler_signature_check, hudson, pry-plus.
- **#1401** instance_methods(false)→[] (after_commit_action, basica, powder, yoshiki).
- Remaining singles documented-not-filed (distinct one-offs, not a cluster): O_o (custom-exception hierarchy false→true), passw (float arithmetic →empty), test (global-var nil→[]), saj_collector/toolbox (VERSION.frozen? true→false).

### miscompiles (real behaviour regressions):
- after_commit_action: rubric:miscompile miscompile diff:L3 cruby="[\"_after_commit_hook\", \"execute_after_commit\"]\n" spinel="[]\n"
- basica: rubric:miscompile miscompile diff:L3 cruby="[:basic_auth]\n" spinel="[]\n"
- bundler_signature_check: rubric:miscompile miscompile diff:L3 cruby="true\n" spinel="false\n"
- hudson: rubric:miscompile miscompile diff:L2 cruby="true\n" spinel="false\n"
- O_o: rubric:miscompile miscompile diff:L5 cruby="false\n" spinel="true\n"
- powder: rubric:miscompile miscompile diff:L2 cruby="[:get_app_origin]\n" spinel="[]\n"
- pry-plus: rubric:miscompile miscompile diff:L3 cruby="true\n" spinel="false\n"
- passw: rubric:miscompile miscompile diff:L5 cruby="74.04\n" spinel="\n"
- saj_collector: rubric:miscompile miscompile diff:L3 cruby="true\n" spinel="false\n"
- test: rubric:miscompile miscompile diff:L2 cruby="nil\n" spinel="[]\n"
- toolbox: rubric:miscompile miscompile diff:L3 cruby="true\n" spinel="false\n"
- yoshiki: rubric:miscompile miscompile diff:L5 cruby="[:example_for_layout_else_alignment, :example_for_layout_end_alignment]\n" spinel="[]\n"

### build-errors (codegen — triage require-only vs real before filing):
- activerecord-reset-pk-sequence - afm - awes_cli - beef-articles - bychar - Dhalang - free_email_checker - gem-helper - helpful_configuration - little-plugger - logger_pipe - mail-redirector - git_modified_lines - pdftailor - redcar-svnkit - rhyme - require-magic - rubysl-fiber - ruby_version - sensu-plugins-http - shuttlerock_shared_config - simplecov-shields-badge - single_test - strings-ansi - the-perfect-gem - tvd-git - twitter_username_extractor - tvd-runit - tvd-tvdinner - tvd-vagrant - ui_faces 
# Spinel gem-compatibility survey

- engine rev: `git:c51b0a1c/aarch64-linux`
- gems surveyed: **192021**
- compatible (clean+verified): **85407** (44.5%)  ·  risky: 47881  ·  rejected: 58733

## Candidate features — unresolved calls Spinel could learn

_Core/stdlib method calls only; metaprogramming and `require` excluded as known out-of-scope. The top is the real signal; the long tail is mostly calls unresolved only because their defining `require` wasn't followed._

| count | call |
|---|---|
| 31241 | `no-entrypoint` |
| 6756 | `thread` |
| 4685 | `mutex` |
| 302 | `analyze-oom: spinel_analyze OOM/timeout, skipped (matz/spinel#1302)` |
| 239 | `hard:TracePoint` |
| 121 | `hard:set_trace_func` |
| 45 | `mutex_m` |
| 6 | `static-scan-truncated` |

Showing 8 of **8** distinct candidate calls (43395 occurrences).

## Blockers by category

| occurrences | category |
|---|---|
| 43395 | candidate core/stdlib calls (above) |
| 117417 | metaprogramming / reflection — out of scope |
| 0 | no load path: `require` + `needs:` — probe limitation |
| 24107 | analyzer failed / timed out — compiler hardening |
| 2723 | C extensions — uncompilable |

## All blockers (top 100)

| count | reason | category |
|---|---|---|
| 34151 | `send` | metaprog |
| 31241 | `no-entrypoint` | call |
| 24008 | `analyze-failed` | robustness |
| 17385 | `define_method` | metaprog |
| 15940 | `class_eval` | metaprog |
| 15567 | `method_missing` | metaprog |
| 12048 | `instance_eval` | metaprog |
| 6756 | `thread` | call |
| 6149 | `binding` | metaprog |
| 5413 | `eval` | metaprog |
| 5139 | `public_send` | metaprog |
| 4685 | `mutex` | call |
| 2905 | `respond_to_missing` | metaprog |
| 2723 | `c-extension` | cext |
| 1568 | `objectspace` | metaprog |
| 1152 | `const_missing` | metaprog |
| 302 | `analyze-oom: spinel_analyze OOM/timeout, skipped (matz/spinel#1302)` | call |
| 239 | `hard:TracePoint` | call |
| 121 | `hard:set_trace_func` | call |
| 99 | `analyze-timeout` | robustness |
| 45 | `mutex_m` | call |
| 6 | `static-scan-truncated` | call |

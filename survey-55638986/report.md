# Spinel gem-compatibility survey

- engine rev: `git:55638986/aarch64-linux`
- gems surveyed: **192027**
- compatible (clean+verified): **84171** (43.8%)  ·  risky: 46998  ·  rejected: 60858

## Candidate features — unresolved calls Spinel could learn

_Core/stdlib method calls only; metaprogramming and `require` excluded as known out-of-scope. The top is the real signal; the long tail is mostly calls unresolved only because their defining `require` wasn't followed._

| count | call |
|---|---|
| 31242 | `no-entrypoint` |
| 6758 | `thread` |
| 4686 | `mutex` |
| 349 | `analyze-oom: spinel_analyze OOM/timeout, skipped (matz/spinel#1302)` |
| 239 | `hard:TracePoint` |
| 121 | `hard:set_trace_func` |
| 45 | `mutex_m` |
| 8 | `static-scan-truncated` |

Showing 8 of **8** distinct candidate calls (43448 occurrences).

## Blockers by category

| occurrences | category |
|---|---|
| 43448 | candidate core/stdlib calls (above) |
| 117367 | metaprogramming / reflection — out of scope |
| 0 | no load path: `require` + `needs:` — probe limitation |
| 26184 | analyzer failed / timed out — compiler hardening |
| 2723 | C extensions — uncompilable |

## All blockers (top 100)

| count | reason | category |
|---|---|---|
| 34135 | `send` | metaprog |
| 31242 | `no-entrypoint` | call |
| 25951 | `analyze-failed` | robustness |
| 17376 | `define_method` | metaprog |
| 15936 | `class_eval` | metaprog |
| 15562 | `method_missing` | metaprog |
| 12047 | `instance_eval` | metaprog |
| 6758 | `thread` | call |
| 6144 | `binding` | metaprog |
| 5410 | `eval` | metaprog |
| 5134 | `public_send` | metaprog |
| 4686 | `mutex` | call |
| 2904 | `respond_to_missing` | metaprog |
| 2723 | `c-extension` | cext |
| 1567 | `objectspace` | metaprog |
| 1152 | `const_missing` | metaprog |
| 349 | `analyze-oom: spinel_analyze OOM/timeout, skipped (matz/spinel#1302)` | call |
| 239 | `hard:TracePoint` | call |
| 233 | `analyze-timeout` | robustness |
| 121 | `hard:set_trace_func` | call |
| 45 | `mutex_m` | call |
| 8 | `static-scan-truncated` | call |

# Spinel gem-compatibility survey

- engine rev: `git:2814693f/aarch64-linux`
- gems surveyed: **192037**
- compatible (clean+verified): **88379** (46.0%)  ·  risky: 44991  ·  rejected: 58667

## Candidate features — unresolved calls Spinel could learn

_Core/stdlib method calls only; metaprogramming and `require` excluded as known out-of-scope. The top is the real signal; the long tail is mostly calls unresolved only because their defining `require` wasn't followed._

| count | call |
|---|---|
| 31245 | `no-entrypoint` |
| 349 | `analyze-oom: spinel_analyze OOM/timeout, skipped (matz/spinel#1302)` |
| 239 | `hard:TracePoint` |
| 121 | `hard:set_trace_func` |
| 9 | `static-scan-truncated` |

Showing 5 of **5** distinct candidate calls (31963 occurrences).

## Blockers by category

| occurrences | category |
|---|---|
| 31963 | candidate core/stdlib calls (above) |
| 117389 | metaprogramming / reflection — out of scope |
| 0 | no load path: `require` + `needs:` — probe limitation |
| 23990 | analyzer failed / timed out — compiler hardening |
| 2723 | C extensions — uncompilable |

## All blockers (top 100)

| count | reason | category |
|---|---|---|
| 34140 | `send` | metaprog |
| 31245 | `no-entrypoint` | call |
| 23741 | `analyze-failed` | robustness |
| 17380 | `define_method` | metaprog |
| 15937 | `class_eval` | metaprog |
| 15564 | `method_missing` | metaprog |
| 12049 | `instance_eval` | metaprog |
| 6144 | `binding` | metaprog |
| 5409 | `eval` | metaprog |
| 5140 | `public_send` | metaprog |
| 2906 | `respond_to_missing` | metaprog |
| 2723 | `c-extension` | cext |
| 1568 | `objectspace` | metaprog |
| 1152 | `const_missing` | metaprog |
| 349 | `analyze-oom: spinel_analyze OOM/timeout, skipped (matz/spinel#1302)` | call |
| 249 | `analyze-timeout` | robustness |
| 239 | `hard:TracePoint` | call |
| 121 | `hard:set_trace_func` | call |
| 9 | `static-scan-truncated` | call |

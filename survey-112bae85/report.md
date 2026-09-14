# Spinel gem-compatibility survey

- engine rev: `git:112bae85/aarch64-linux`
- gems surveyed: **192038**
- compatible (clean+verified): **84511** (44.0%)  ·  risky: 47027  ·  rejected: 60500

## Candidate features — unresolved calls Spinel could learn

_Core/stdlib method calls only; metaprogramming and `require` excluded as known out-of-scope. The top is the real signal; the long tail is mostly calls unresolved only because their defining `require` wasn't followed._

| count | call |
|---|---|
| 31242 | `no-entrypoint` |
| 6761 | `thread` |
| 4690 | `mutex` |
| 349 | `analyze-oom: spinel_analyze OOM/timeout, skipped (matz/spinel#1302)` |
| 239 | `hard:TracePoint` |
| 121 | `hard:set_trace_func` |
| 45 | `mutex_m` |
| 5 | `static-scan-truncated` |

Showing 8 of **8** distinct candidate calls (43452 occurrences).

## Blockers by category

| occurrences | category |
|---|---|
| 43452 | candidate core/stdlib calls (above) |
| 117386 | metaprogramming / reflection — out of scope |
| 0 | no load path: `require` + `needs:` — probe limitation |
| 25826 | analyzer failed / timed out — compiler hardening |
| 2723 | C extensions — uncompilable |

## All blockers (top 100)

| count | reason | category |
|---|---|---|
| 34139 | `send` | metaprog |
| 31242 | `no-entrypoint` | call |
| 25701 | `analyze-failed` | robustness |
| 17379 | `define_method` | metaprog |
| 15937 | `class_eval` | metaprog |
| 15564 | `method_missing` | metaprog |
| 12049 | `instance_eval` | metaprog |
| 6761 | `thread` | call |
| 6144 | `binding` | metaprog |
| 5410 | `eval` | metaprog |
| 5139 | `public_send` | metaprog |
| 4690 | `mutex` | call |
| 2906 | `respond_to_missing` | metaprog |
| 2723 | `c-extension` | cext |
| 1567 | `objectspace` | metaprog |
| 1152 | `const_missing` | metaprog |
| 349 | `analyze-oom: spinel_analyze OOM/timeout, skipped (matz/spinel#1302)` | call |
| 239 | `hard:TracePoint` | call |
| 125 | `analyze-timeout` | robustness |
| 121 | `hard:set_trace_func` | call |
| 45 | `mutex_m` | call |
| 5 | `static-scan-truncated` | call |

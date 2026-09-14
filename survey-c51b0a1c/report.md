# Spinel gem-compatibility survey

- engine rev: `git:c51b0a1c/aarch64-linux`
- gems surveyed: **189751**
- compatible (clean+verified): **84493** (44.5%)  ·  risky: 47563  ·  rejected: 57695

## Candidate features — unresolved calls Spinel could learn

_Core/stdlib method calls only; metaprogramming and `require` excluded as known out-of-scope. The top is the real signal; the long tail is mostly calls unresolved only because their defining `require` wasn't followed._

| count | call |
|---|---|
| 30719 | `no-entrypoint` |
| 6556 | `thread` |
| 4404 | `mutex` |
| 349 | `analyze-oom: spinel_analyze OOM/timeout, skipped (matz/spinel#1302)` |
| 228 | `hard:TracePoint` |
| 121 | `hard:set_trace_func` |
| 45 | `mutex_m` |
| 6 | `static-scan-truncated` |

Showing 8 of **8** distinct candidate calls (42428 occurrences).

## Blockers by category

| occurrences | category |
|---|---|
| 42428 | candidate core/stdlib calls (above) |
| 116209 | metaprogramming / reflection — out of scope |
| 0 | no load path: `require` + `needs:` — probe limitation |
| 23612 | analyzer failed / timed out — compiler hardening |
| 2666 | C extensions — uncompilable |

## All blockers (top 100)

| count | reason | category |
|---|---|---|
| 33914 | `send` | metaprog |
| 30719 | `no-entrypoint` | call |
| 23539 | `analyze-failed` | robustness |
| 17220 | `define_method` | metaprog |
| 15865 | `class_eval` | metaprog |
| 15471 | `method_missing` | metaprog |
| 11972 | `instance_eval` | metaprog |
| 6556 | `thread` | call |
| 6082 | `binding` | metaprog |
| 5365 | `eval` | metaprog |
| 4829 | `public_send` | metaprog |
| 4404 | `mutex` | call |
| 2819 | `respond_to_missing` | metaprog |
| 2666 | `c-extension` | cext |
| 1533 | `objectspace` | metaprog |
| 1139 | `const_missing` | metaprog |
| 349 | `analyze-oom: spinel_analyze OOM/timeout, skipped (matz/spinel#1302)` | call |
| 228 | `hard:TracePoint` | call |
| 121 | `hard:set_trace_func` | call |
| 73 | `analyze-timeout` | robustness |
| 45 | `mutex_m` | call |
| 6 | `static-scan-truncated` | call |

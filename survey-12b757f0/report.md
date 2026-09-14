# Spinel gem-compatibility survey

- engine rev: `git:12b757f0/aarch64-linux`
- gems surveyed: **189728**
- compatible (clean+verified): **83285** (43.9%)  ·  risky: 45667  ·  rejected: 60776

## Candidate features — unresolved calls Spinel could learn

_Core/stdlib method calls only; metaprogramming and `require` excluded as known out-of-scope. The top is the real signal; the long tail is mostly calls unresolved only because their defining `require` wasn't followed._

| count | call |
|---|---|
| 30719 | `no-entrypoint` |
| 6553 | `thread` |
| 4402 | `mutex` |
| 349 | `analyze-oom: spinel_analyze OOM/timeout, skipped (matz/spinel#1302)` |
| 228 | `hard:TracePoint` |
| 118 | `hard:set_trace_func` |
| 45 | `mutex_m` |
| 11 | `load-path:require` |

Showing 8 of **8** distinct candidate calls (42425 occurrences).

## Blockers by category

| occurrences | category |
|---|---|
| 42425 | candidate core/stdlib calls (above) |
| 116197 | metaprogramming / reflection — out of scope |
| 0 | no load path: `require` + `needs:` — probe limitation |
| 26696 | analyzer failed / timed out — compiler hardening |
| 2666 | C extensions — uncompilable |

## All blockers (top 100)

| count | reason | category |
|---|---|---|
| 33914 | `send` | metaprog |
| 30719 | `no-entrypoint` | call |
| 26627 | `analyze-failed` | robustness |
| 17217 | `define_method` | metaprog |
| 15864 | `class_eval` | metaprog |
| 15472 | `method_missing` | metaprog |
| 11971 | `instance_eval` | metaprog |
| 6553 | `thread` | call |
| 6080 | `binding` | metaprog |
| 5361 | `eval` | metaprog |
| 4827 | `public_send` | metaprog |
| 4402 | `mutex` | call |
| 2819 | `respond_to_missing` | metaprog |
| 2666 | `c-extension` | cext |
| 1533 | `objectspace` | metaprog |
| 1139 | `const_missing` | metaprog |
| 349 | `analyze-oom: spinel_analyze OOM/timeout, skipped (matz/spinel#1302)` | call |
| 228 | `hard:TracePoint` | call |
| 118 | `hard:set_trace_func` | call |
| 69 | `analyze-timeout` | robustness |
| 45 | `mutex_m` | call |
| 11 | `load-path:require` | call |

# Spinel gem-compatibility survey

- engine rev: `git:76cfd099/aarch64-linux`
- gems surveyed: **189751**
- compatible (clean+verified): **84204** (44.4%)  ·  risky: 47001  ·  rejected: 58546

## Candidate features — unresolved calls Spinel could learn

_Core/stdlib method calls only; metaprogramming and `require` excluded as known out-of-scope. The top is the real signal; the long tail is mostly calls unresolved only because their defining `require` wasn't followed._

| count | call |
|---|---|
| 30719 | `no-entrypoint` |
| 6557 | `thread` |
| 4404 | `mutex` |
| 349 | `analyze-oom: spinel_analyze OOM/timeout, skipped (matz/spinel#1302)` |
| 228 | `hard:TracePoint` |
| 121 | `hard:set_trace_func` |
| 45 | `mutex_m` |
| 11 | `load-path:require` |

Showing 8 of **8** distinct candidate calls (42434 occurrences).

## Blockers by category

| occurrences | category |
|---|---|
| 42434 | candidate core/stdlib calls (above) |
| 116215 | metaprogramming / reflection — out of scope |
| 0 | no load path: `require` + `needs:` — probe limitation |
| 24463 | analyzer failed / timed out — compiler hardening |
| 2666 | C extensions — uncompilable |

## All blockers (top 100)

| count | reason | category |
|---|---|---|
| 33917 | `send` | metaprog |
| 30719 | `no-entrypoint` | call |
| 24386 | `analyze-failed` | robustness |
| 17220 | `define_method` | metaprog |
| 15866 | `class_eval` | metaprog |
| 15473 | `method_missing` | metaprog |
| 11972 | `instance_eval` | metaprog |
| 6557 | `thread` | call |
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
| 77 | `analyze-timeout` | robustness |
| 45 | `mutex_m` | call |
| 11 | `load-path:require` | call |

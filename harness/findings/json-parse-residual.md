# Finding: two residual bundled-`json` bugs (post-#1844 re-verify)

After matz/spinel#1844 resolved (`JSON.parse`/`pretty_generate` now resolve,
silent-0 gate flipped default-on), rebuilt the engine to master `git:bae3dbf2`
and re-verified the multi_json mirror compiled. The common path now works
(`generate`, `parse` of string-keyed objects/arrays/scalars, `pretty_generate`,
round-trip). Two residual bugs remain, both in the bundled `json`, both surfaced
by the mirror's conformance test.

## Part 1 — `JSON.parse(str, symbolize_names: true)` ignores the keyword

| | CRuby | Spinel `bae3dbf2` |
|---|---|---|
| `JSON.parse('{"a":1}', symbolize_names: true)` | `{a: 1}` | `{"a" => 1}` |

The `symbolize_names:` option is not applied — string keys are returned. Blocks
the mirror's `:symbolize_keys` path. (Not the typed-vs-poly hash-equality gap matz
flagged when closing #1844: string-keyed equality works — `load_hash` passes — so
the keys are genuinely string, not a comparison artifact.)

## Part 2 — the ParserError raised *inside* `JSON.parse` escapes `rescue JSON::ParserError`

| | CRuby | Spinel `bae3dbf2` |
|---|---|---|
| `JSON.parse("{bad}")` then `rescue JSON::ParserError` | caught | **escapes** (caught only by bare `rescue`; `e.class` == `JSON::ParserError`) |
| `raise JSON::ParserError` then `rescue JSON::ParserError` | caught | caught ✓ |
| `raise MyErr` then `rescue MyErr` | caught | caught ✓ |

Rescue-by-class works generally (controls pass); only the error `JSON.parse`
raises *internally* is not matched by a `rescue JSON::ParserError` at the call
site — its class is not identical to the `JSON::ParserError` constant the caller
references (a dual-constant identity mismatch inside the bundled json package).
This aborted the compiled mirror test: `MultiJson.load`'s `rescue ::JSON::ParserError`
misses, so the error propagates uncaught and the binary exits early.

## Impact on the mirror

Went from fully blocked (`parse` → 0, #1844) to two residual json bugs. `dump`,
`load` (string keys), pretty, round-trip all match CRuby compiled. Remaining mirror
blockers: `:symbolize_keys` (Part 1) and error-wrapping (Part 2). Publish once both
resolve. (One further oddity, not filed: `MultiJson.dump` of a symbol-keyed hash is
byte-correct in isolation but fails inside the full multi-callsite test — looks like
whole-program inference specialization, not a clean standalone bug.)

## Repro

`json-parse-residual.rb` (this dir); deterministic at `git:bae3dbf2`.

## Related

Follow-on to `json-parse-emits-0.md` / matz/spinel#1844 (resolved). matz invited
these "with the shape" in his #1844 close.

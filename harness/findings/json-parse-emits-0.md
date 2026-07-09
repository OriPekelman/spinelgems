# Finding: Spinel's bundled `json` resolves `generate` but not `parse` (silent 0)

Surfaced 2026-07-09 driving the **multi_json mirror** (`~/sites/spinel-multi_json`)
through the mirror-porter skeleton. Engine rev `git:60070a6/aarch64-linux`.

## The bug

`require "json"` then:

| call | CRuby | Spinel (compiled) |
|---|---|---|
| `JSON.generate([1,2])` | `[1,2]` | `[1,2]` ✓ |
| `JSON.parse("[1,2]")` | `[1, 2]` | **`0`** ✗ |
| `JSON.parse("42")` | `42` | **`0`** ✗ |
| `JSON.pretty_generate(x)` | pretty | **`0`** ✗ |

The unresolved calls **emit 0 silently** (no raise, exit 0). Compiler warning,
present even under `SPINEL_GATE_RAISE=1` (it warns but still emits 0):

```
warning: in (top level): cannot resolve call to 'parse' on int (emitting 0)
```

So the bundled `json` package exposes `generate` as resolvable but `parse` /
`pretty_generate` degrade to the "unsupported call → Int 0" path. `require "json"`
itself succeeds (no missing-require warning) — it's specific to these methods.

## Why it matters

- **Silent, not loud.** A `0` returned with no error is the exact silent-miscompile
  class the differential harness exists to catch; a mirror that shipped this would
  violate matz/spinel#1753 condition #3 (loud failure outside the ledger).
- **Foundational.** JSON round-tripping underlies a large fraction of the corpus,
  not just multi_json. Fixing `parse`/`pretty_generate` unblocks far more than one
  mirror.

## Secondary (situational): silent-0 poisons return-type inference

In `MultiJson.dump` (a `module_function` branching on `options[:pretty]`), the
unresolved `pretty_generate` branch made the whole method's inferred return type
unify to `mrb_int`, so even the working `JSON.generate` branch was int-cast to `0`
(C warning: `returning 'const char *' from a function with return type 'mrb_int'
… makes integer from pointer without a cast`). It did **not** reproduce in a plain
top-level method with a boolean flag, so it looks structural (module_function +
options-hash), and the primary repro above stands alone.

## Repro

`json-parse-emits-0.rb` (this dir). Primary bug is 3 lines, deterministic.

## Status

Blocks publication of the multi_json mirror (load/decode path). Filing upstream
at matz/spinel — the fix (resolve `JSON.parse`/`pretty_generate`, or at minimum
make the unresolved call raise instead of emit 0) unblocks it.

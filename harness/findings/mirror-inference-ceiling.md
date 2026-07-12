# Finding: Spinel whole-program inference ceiling on medium-sized mirrors

Building three mirrors through `spinel-compat mirror-init` mapped a clear line in
Spinel's whole-program inference (engine `git:65fb6d2d`):

- **multi_json** (thin: one module, ~6 module_functions delegating to stdlib) —
  clean 17/17 compiled. (Surfaced #1844/#1853/#2009, all clean minimal bugs, fixed.)
- **colorize** (~50 explicit String methods, regex parse, `case` code maps) —
  clean 19/19 compiled, once written to avoid the fragile constructs below.
- **addressable** (`URI` value-class: ~15 methods, operators, recursion) —
  **hit a cluster of context-dependent failures that do NOT minimize.**

## The addressable cluster (all context-dependent — compile standalone, fail in the class)

| construct | symptom | workaround |
|---|---|---|
| `a, b, ... = x, y, ...` in a class method | `unsupported multiple assignment (MultiWriteNode)` | individual assignments |
| keyword-arg constructor, call sites passing different subsets | inconsistent `sp_URI_new` arity (`too few arguments`) | positional constructor, uniform arity |
| a method literally named **`join`** | return type collapses to `String` (even when it only delegates) | rename impl; but public `.join` stays broken |
| user **`==`** operator in the rich class | not dispatched — falls back to Object identity (`eql?` alias *does* reach the method) | none found; blocks value-equality |

Each construct compiles fine in a minimal file; they only fail inside the full
`URI` class. So they're not cleanly filable as minimal repros — the signal is the
**pattern**: inference degrades on a moderately rich single value-class with
operator overloads, recursion (`join` → `parse` → `remove_dot_segments`), and
method-name collisions with builtins (`join`).

## What made colorize succeed where addressable didn't

Written deliberately to sidestep the fragile constructs:
- `case` code maps, **not** symbol-keyed hashes;
- **no** `a, b = ...` multiple assignment (array indexing);
- **no** operator methods (`==`) or builtin-name collisions (`join`);
- return types pinned where MatchData#[] made them nilable (`uncolorize` → `.to_s`).

So the practical guidance for mirror authors today: **prefer thin, functional,
non-value-class surfaces**; avoid operator overloads, recursion-heavy methods,
and method names that shadow Array/String builtins, until the inference handles them.

## Status

addressable is PAUSED (its read/normalize surface is a clean shippable v0.1 —
20/20 compiled — but join/`+`/`==` are blocked). Not filed as issues (no minimal
repros). Related clean finding: `string-inspect-esc.rb` (ESC → `\x1B` vs `\e`).

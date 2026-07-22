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

## Re-verify at 12b757f0 (2026-07-22, 981 commits after 65fb6d2d)

All three mirrors re-pass `bin/verify` (multi_json 1/1, colorize 1/1 + oracle,
addressable v0.1 1/1 + oracle). Re-probing the paused constructs in-context:

| construct | at 65fb6d2d | at 12b757f0 |
|---|---|---|
| `a, b = x, y` in a class method | (orig: MultiWriteNode error) | **works** (2-target shape; also works at 65fb6d2d) |
| kwarg constructor, differing call-site subsets | works (kwarg `initialize`, 4 subsets) | **works** |
| user `+` operator returning the class | **FAIL** (silent wrong dispatch) | **FIXED** (user-binop wave, e.g. 3e376f5b) |
| user `==` in the rich class | works in current shape | **works** |
| method named `join` | collapses | **STILL COLLAPSES** — but now REDUCED to 17 lines: `join-builtin-shadow-union.rb`. Two ingredients: builtin-shadowing name + String-including union receiver from an un-narrowed `return uri if uri.is_a?(URI)` guard. No longer "doesn't minimize". |

New in-context bug surfaced en route: `"str".is_a?(Qualified::UserClass)` →
runtime NoMethodError (residual variant of fixed #2683, which only covered
::-scoped builtin classes). Repro: `isa-qualified-user-class.rb`.

So the ceiling has LIFTED for operators/massign/kwargs; what remains is the
builtin-name-shadowing dispatch on union receivers (join) and the qualified
user-class `is_a?`. Both FILED 2026-07-22: matz/spinel#3258 (is_a?) and #3259 (join). Both are clean minimal repros — unlike the
original cluster. addressable can un-pause once those two land (join is the
only public-surface blocker; `+` already works if it delegates to a
non-shadowing name).

Side observation (colorize, 12b757f0): generated C declares `clr_set`'s param
`const char *` while call sites pass `sp_String *` — compiles with
-Wincompatible-pointer-types warnings, output still byte-correct. Watch it.

## Status (original, engine 65fb6d2d — superseded above)

addressable is PAUSED (its read/normalize surface is a clean shippable v0.1 —
20/20 compiled — but join/`+`/`==` are blocked). Not filed as issues (no minimal
repros). Related clean finding: `string-inspect-esc.rb` (ESC → `\x1B` vs `\e`).

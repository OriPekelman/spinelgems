# Finding: two edges after the #1853 fix (mirror re-verify at `e6513188`)

matz/spinel#1853 fixed both its parts (`JSON.parse` `symbolize_names:` + `rescue
JSON::ParserError`). Rebuilt to master `e6513188` and re-verified the multi_json
mirror compiled: it went from 12/17 to **16/17**, and the real-gem oracle passes
1/1. Two narrower edges remain, both relatives of already-fixed bugs.

## Edge A — `rescue ::JSON::ParserError` (leading `::`) misses the internal raise

| rescue form | CRuby | Spinel `e6513188` |
|---|---|---|
| `rescue JSON::ParserError` | caught | caught ✓ (fixed in #1853) |
| `rescue ::JSON::ParserError` | caught | **leaks** (`e.class` = `JSON::ParserError`) |

The #1853 fix matched the qualified-path rescue form to the parser's raised name
`"JSON::ParserError"`; the `::`-rooted `ConstantPathNode` still compiles to a
different leaf and doesn't match. CRuby treats both forms identically.

**Worked around in the mirror** (`multi_json/core.rb`: `rescue JSON::ParserError`,
no `::`) — so this doesn't block publication, but it's a real remaining edge.

## Edge B — `JSON.generate` of a symbol-keyed hash through a poly-hash slot → 0

```ruby
def g(o); JSON.generate(o); end
g({ "a" => 1 })          # string-keyed callsite makes the param a poly hash
p g(:k => "v")           # CRuby: "{\"k\":\"v\"}"   Spinel: "0"
```

When one method param is called with both a string-keyed and a symbol-keyed hash,
inference unifies it to a poly hash (`sp_SymPolyHash` in the generated C), and
`JSON.generate` of that runtime kind emits `0` — it doesn't dispatch on the
poly-hash kind (cf. the recent poly-slot codegen work, `1709f051` "FFI array args
from a poly slot dispatch on the runtime kind"; `JSON.generate` needs the same).
Called with a single key-kind it is correct. This is the mirror's one remaining
compiled failure (`dump_symkey`): the conformance test dumps both string- and
symbol-keyed hashes through `MultiJson.dump`, so the symbol case returns `0`.

## Status

RESOLVED — matz/spinel#2009, fixed at master `65fb6d2d` (6fc17901: "root-anchored
rescue paths and packed keywords into a poly param"). Edge A: the rescue rebuild now
walks the whole constant-path parent chain, so `::JSON::ParserError` matches. Edge B:
root cause was a trailing-keyword collapse (not the JSON writer) — a param fed both a
string-keyed hash and bare keywords widened to a poly slot the collapse zero-padded,
so the symbol-keyed `dump(:k => "v")` serialized a boxed int 0; a poly positional now
receives the packed keywords boxed. Verified at `65fb6d2d`: repro clean, multi_json
mirror **17/17 compiled + oracle 1/1**. Follow-on to `json-parse-residual.md` /
matz/spinel#1853.

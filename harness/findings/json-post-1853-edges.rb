# Two edges surfaced re-verifying the multi_json mirror after matz/spinel#1853
# was fixed (JSON.parse symbolize_names + `rescue JSON::ParserError` now work at
# engine git:e6513188). Both are narrower relatives of already-fixed bugs.
#
#   $ spinel harness/findings/json-post-1853-edges.rb -o /tmp/e.bin && /tmp/e.bin
#   A plain=caught abs=leak:JSON::ParserError
#   B sym="0"
#
# Edge A — `rescue ::JSON::ParserError` (leading `::` absolute constant path) does
# NOT match the error JSON.parse raises internally, though `rescue JSON::ParserError`
# (no `::`) now does. The #1853 fix matched the qualified path form to the raised
# name; the `::`-rooted ConstantPathNode still compiles to a different leaf.
# CRuby treats both identically. (Worked around in the mirror by dropping the `::`.)
#
# Edge B — `JSON.generate` of a symbol-keyed hash returns 0 when the value flows
# through a POLY-HASH slot: a method param called with both a string-keyed and a
# symbol-keyed hash unifies to sp_SymPolyHash, and JSON.generate of that runtime
# kind emits 0 (no dispatch on the poly-hash kind — cf. the recent poly-slot
# codegen work, 1709f051). Called with only one key-kind, it is correct.
require "json"

# Edge A
a1 = begin; JSON.parse("{bad}"); "no"; rescue JSON::ParserError; "caught"; rescue => e; "leak:#{e.class}"; end
a2 = begin; JSON.parse("{bad}"); "no"; rescue ::JSON::ParserError; "caught"; rescue => e; "leak:#{e.class}"; end
puts "A plain=#{a1} abs=#{a2}"

# Edge B
def g(o); JSON.generate(o); end
g({ "a" => 1 })                      # string-keyed callsite -> param becomes poly
puts "B sym=#{g(:k => "v").inspect}" # symbol-keyed callsite -> 0

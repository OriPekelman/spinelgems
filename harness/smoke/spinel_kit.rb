# Behaviour smoke for spinel_kit (SpinelKit::Json) — the Spinel stdlib-surface
# gem. Exercises real JSON encoding logic: escaping, quoting, and hash/array
# encoders, with control chars and quote/backslash edge cases.
#
# Receivers are FULLY QUALIFIED (SpinelKit::Json.x, not a `J = SpinelKit::Json`
# alias): a method call on a constant *alias* is unsupported under Spinel
# (matz/spinel#1399) — the direct constant path compiles + matches CRuby.
require "spinel_kit"

# escape: control chars + quote + backslash -> JSON-legal escapes
puts SpinelKit::Json.escape(%(a"b\\c) + "\n\t")
# quote wraps + escapes
puts SpinelKit::Json.quote("hi\tthere")
# encode_pair_str / _int
puts SpinelKit::Json.encode_pair_str("name", "ada")
puts SpinelKit::Json.encode_pair_int("age", 42)
# from_str_hash (ordered)
puts SpinelKit::Json.from_str_hash({ "k1" => "v1", "k2" => "v\"2" })
# from_str_array
puts SpinelKit::Json.from_str_array(["x", "y\\z"])
# hex2 boundary
puts SpinelKit::Json.hex2(7)
puts SpinelKit::Json.hex2(255)

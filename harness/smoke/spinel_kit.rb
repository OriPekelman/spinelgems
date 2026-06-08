# Behaviour smoke for spinel_kit (SpinelKit::Json) — the Spinel stdlib-surface
# gem. Exercises real JSON encoding logic: escaping, quoting, and hash/array
# encoders, with control chars and quote/backslash edge cases.
require "spinel_kit"

J = SpinelKit::Json

# escape: control chars + quote + backslash -> JSON-legal escapes
puts J.escape(%(a"b\\c) + "\n\t")
# quote wraps + escapes
puts J.quote("hi\tthere")
# encode_pair_str / _int
puts J.encode_pair_str("name", "ada")
puts J.encode_pair_int("age", 42)
# from_str_hash (ordered)
puts J.from_str_hash({ "k1" => "v1", "k2" => "v\"2" })
# from_str_array
puts J.from_str_array(["x", "y\\z"])
# hex2 boundary
puts J.hex2(7)
puts J.hex2(255)

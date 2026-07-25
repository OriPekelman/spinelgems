# Behaviour smoke for spinel_kit 0.3.0+ (spin package shape). SpinelKit::Json
# was retired in 0.3.0 (Spinel bundles `json` as a stdlib package) — the
# surface is now Hex / Url (+ Git/Log, which need a repo / clock and stay out
# of a deterministic smoke). Exercises real encode/decode logic both ways.
#
# Receivers are FULLY QUALIFIED (SpinelKit::Hex.x, not an `H =` alias): a
# method call on a constant alias is unsupported under Spinel (matz/spinel#1399).
require "spinel_kit"

# Hex: nibble/byte encode + decode round-trips, case-insensitive to_int
puts SpinelKit::Hex.byte2(0)
puts SpinelKit::Hex.byte2(171)
puts SpinelKit::Hex.byte2(255)
puts SpinelKit::Hex.to_int("ff")
puts SpinelKit::Hex.to_int("AB")
puts SpinelKit::Hex.nibble_char(10)

# Url: percent escape/unescape round-trip
puts SpinelKit::Url.escape("a b&c=d")
puts SpinelKit::Url.unescape("a%20b%26c%3Dd")
puts SpinelKit::Url.unescape(SpinelKit::Url.escape("x/y?z"))

# parse_query: ordered pairs, empty values, repeated keys (last wins)
puts SpinelKit::Url.parse_query("a=1&b=&a=2").inspect

# split_url: scheme/host/port/path/query decomposition
puts SpinelKit::Url.split_url("https://example.com:8443/p/q?x=1").inspect
puts SpinelKit::Url.split_url("http://h/only").inspect

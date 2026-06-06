# encoding: utf-8
# Smoke test for utf8_utils gem
# Exercises: tidy_bytes (normal), tidy_bytes (force=true), tidy_bytes! (in-place)
# and the CP1252 constant mapping.

require 'utf8_utils'

# 1. ASCII passthrough — valid ASCII must not be changed
ascii = "Hello, World!"
puts ascii.tidy_bytes

# 2. CP1252 single-byte conversion
# \x80 is the Euro sign in CP1252 -> should become "€"
euro_raw = "\x80".b.force_encoding("UTF-8")
puts euro_raw.tidy_bytes

# \x94 (CP1252 right double quotation mark) -> should become "”" (")
rdq_raw = "\x94".b.force_encoding("UTF-8")
puts rdq_raw.tidy_bytes

# 3. Latin-1 / ISO-8859-1 range: bytes 0xC0..0xFF (not CP1252 range)
# \xC0 alone (leading byte with no continuation) should tidy to "À"
c0_raw = "\xC0".b.force_encoding("UTF-8")
puts c0_raw.tidy_bytes

# 4. Mixed valid UTF-8 + invalid bytes
# The valid UTF-8 part ("café") is left as-is; the trailing \x80 gets tidied
mixed = "caf\xC3\xA9\x80".b.force_encoding("UTF-8")
puts mixed.tidy_bytes

# 5. Force mode: treat every byte as CP1252/Latin-1 regardless of validity
# "\xC2\xBB" is valid UTF-8 for "»" but force=true re-interprets each raw byte
valid_utf8 = "\xC2\xBB".b.force_encoding("UTF-8")
puts valid_utf8.tidy_bytes(true)

# 6. In-place variant tidy_bytes!
s = "\x80\x94".b.force_encoding("UTF-8")
s.tidy_bytes!
puts s

# 7. CP1252 constant: spot-check key entries
puts UTF8Utils::CP1252[128].inspect   # Euro sign bytes
puts UTF8Utils::CP1252[129].inspect   # nil (no mapping)
puts UTF8Utils::CP1252[159].inspect   # Ÿ bytes

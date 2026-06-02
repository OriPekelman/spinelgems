# Exercises ROTP::Base32 encode/decode — pure Ruby, no OpenSSL, no randomness
puts ROTP::Base32::CHARS.first(8).join
puts ROTP::Base32::SHIFT
puts ROTP::Base32::MASK

# Round-trip encode then decode a known byte string
original = "Hello"
encoded = ROTP::Base32.encode(original)
puts encoded
decoded = ROTP::Base32.decode(encoded)
puts decoded

# Another known round-trip
encoded2 = ROTP::Base32.encode("ROTP")
puts encoded2
puts ROTP::Base32.decode(encoded2)

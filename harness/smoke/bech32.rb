# Bech32 encode/decode smoke — no external deps, pure arithmetic
puts Bech32::CHARSET.length
puts Bech32::SEPARATOR
puts Bech32::BECH32M_CONST.to_s(16)

# Encode a simple BECH32 address
encoded = Bech32.encode('bc', [0, 14, 20, 15, 7, 13, 26, 0, 25, 18, 6, 11, 13, 8, 21, 4, 20, 3, 17, 2, 29, 3, 12, 29, 3, 4, 15, 24, 20, 6, 14, 30, 22], Bech32::Encoding::BECH32)
puts encoded

# Decode it back
hrp, data, spec = Bech32.decode(encoded)
puts hrp
puts spec
puts data.inspect

# convert_bits round-trip
orig = [0, 1, 2, 3, 255]
converted = Bech32.convert_bits(orig, 8, 5)
puts converted.inspect

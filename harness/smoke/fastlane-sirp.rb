# Drive the pure-computation helpers in SIRP (no network, no randomness)
puts SIRP::VERSION

# Include SIRP into a helper object to call module methods
obj = Object.new
obj.extend(SIRP)

# num_to_hex: integer to downcased even-length hex string
puts obj.num_to_hex(255)
puts obj.num_to_hex(256)
puts obj.num_to_hex(0)
puts obj.num_to_hex(16)

# hex_to_bytes: hex string -> array of integer bytes
puts obj.hex_to_bytes("48656c6c6f").inspect

# secure_compare: constant-time string comparison
puts obj.secure_compare("abc", "abc")
puts obj.secure_compare("abc", "xyz")
puts obj.secure_compare("ab", "abc")

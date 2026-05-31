# crockford32 smoke — encode/decode integers and strings
puts Crockford32.encode(0)
puts Crockford32.encode(1)
puts Crockford32.encode(255)
puts Crockford32.encode(12345)
puts Crockford32.encode(12345, length: 8)
puts Crockford32.decode("0")
puts Crockford32.decode("Z")
puts Crockford32.decode("7W")
puts Crockford32.encode(12345, check: true)
puts Crockford32::ENCODED_BITS

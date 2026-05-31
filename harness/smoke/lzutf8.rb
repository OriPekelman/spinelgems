puts LZUTF8::VERSION
puts LZUTF8::MINIMUM_SEQUENCE_LENGTH
puts LZUTF8::MAXIMUM_SEQUENCE_LENGTH
puts LZUTF8::MAXIMUM_MATCH_DISTANCE

# Decompress passes plain UTF-8 through unchanged
plain = "hello world"
puts LZUTF8.decompress(plain)

# Compress then decompress must round-trip
text = "abcdabcdabcdabcd"
roundtrip = LZUTF8.decompress(LZUTF8.compress(text))
puts roundtrip
puts roundtrip == text

# pointer_info on a known 2-byte pointer
len, dist = LZUTF8.pointer_info([0b11000100, 0b00001010])
puts len
puts dist

require 'adler32'

# Exercise Adler32.calc with known inputs (Wikipedia example: "Wikipedia")
result1 = Adler32.calc("Wikipedia")
puts result1

# Exercise Adler32.checksum (hex formatted)
cs1 = Adler32.checksum("Wikipedia")
puts cs1

# Short string
result2 = Adler32.calc("abc")
puts result2

# Empty string
result3 = Adler32.calc("")
puts result3

# Multi-arg call
result4 = Adler32.calc("Hel", "lo")
result5 = Adler32.calc("Hello")
puts result4 == result5

# Long string to exercise the modular reduction path (> 1000 chars)
long_str = "a" * 2000
result6 = Adler32.calc(long_str)
puts result6

# Checksum of longer string
cs2 = Adler32.checksum("Hello, world!")
puts cs2

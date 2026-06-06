require 'djb2'

# Basic known hash values for the DJB2 XOR variant
puts DJB2.digest("")           # empty string
puts DJB2.digest("a")          # single byte
puts DJB2.digest("hello")      # short string
puts DJB2.digest("hello world") # longer string — exercises the 4-byte-at-a-time loop plus tail bytes

# Binary-safe: test with bytes beyond ASCII
puts DJB2.digest("\xFF\x00\xAB") # raw bytes

# Multiple distinct strings produce distinct hashes
h1 = DJB2.digest("foo")
h2 = DJB2.digest("bar")
puts h1 == h2  # should be false
puts h1 > 0    # hash is a positive integer

# TypeError for non-string
begin
  DJB2.digest(42)
rescue TypeError => e
  puts e.message
end

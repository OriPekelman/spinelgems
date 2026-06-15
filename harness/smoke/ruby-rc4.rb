require_relative "lib/rc4"

rc4 = RC4.new("secret")
puts rc4.encrypt("Hello").bytes.map { |b| "%02x" % b }.join
rc4 = RC4.new("secret")
puts rc4.encrypt("World").bytes.map { |b| "%02x" % b }.join
rc4 = RC4.new("key123")
enc = rc4.encrypt("test data")
rc4b = RC4.new("key123")
puts rc4b.decrypt(enc) == "test data"
rc4 = RC4.new("k")
puts rc4.encrypt("a").bytes.map { |b| "%02x" % b }.join

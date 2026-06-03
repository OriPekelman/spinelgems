# Smoke: rubysl-securerandom — exercises SecureRandom structural properties

# hex: length is 2*n, only hex chars
h = SecureRandom.hex(8)
puts h.length == 16 ? "hex_len:ok" : "hex_len:FAIL(#{h.length})"
puts h.match?(/\A[0-9a-f]+\z/) ? "hex_charset:ok" : "hex_charset:FAIL"

# base64: valid base64 chars, no newlines
b = SecureRandom.base64(12)
puts b.match?(/\A[A-Za-z0-9+\/=]+\z/) ? "base64_charset:ok" : "base64_charset:FAIL"
puts b.include?("\n") ? "base64_newline:FAIL" : "base64_no_newline:ok"

# urlsafe_base64: no + or / or =, uses - and _
u = SecureRandom.urlsafe_base64(12)
puts u.match?(/\A[A-Za-z0-9\-_]+\z/) ? "urlsafe_charset:ok" : "urlsafe_charset:FAIL"

# random_number(n): integer in [0,n)
r = SecureRandom.random_number(100)
puts (r.is_a?(Integer) && r >= 0 && r < 100) ? "random_number_int:ok" : "random_number_int:FAIL(#{r.inspect})"

# random_number(): float in [0,1)
f = SecureRandom.random_number
puts (f.is_a?(Float) && f >= 0.0 && f < 1.0) ? "random_number_float:ok" : "random_number_float:FAIL(#{f.inspect})"

# uuid: matches v4 UUID pattern
uuid = SecureRandom.uuid
puts uuid.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/) \
  ? "uuid_format:ok" : "uuid_format:FAIL(#{uuid.inspect})"

puts "done"

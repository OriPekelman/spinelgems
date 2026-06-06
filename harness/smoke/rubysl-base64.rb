require 'base64'

# encode64 / decode64 (RFC 2045, wraps at 60 chars)
msg = 'Send reinforcements'
enc = Base64.encode64(msg)
puts enc.chomp   # strip trailing newline for deterministic output
puts Base64.decode64(enc)

# strict_encode64 / strict_decode64 (RFC 4648, no line breaks)
data = 'Hello, Spinel!'
strict = Base64.strict_encode64(data)
puts strict
puts Base64.strict_decode64(strict)

# urlsafe_encode64 / urlsafe_decode64 (uses - and _ instead of + and /)
binary = "\xfb\xff\xfe"
url_enc = Base64.urlsafe_encode64(binary)
puts url_enc
puts Base64.urlsafe_decode64(url_enc).bytes.inspect

# round-trip a longer string to exercise wrapping
long = 'The quick brown fox jumps over the lazy dog. ' * 3
rt = Base64.decode64(Base64.encode64(long))
puts rt == long ? 'roundtrip ok' : 'roundtrip FAIL'

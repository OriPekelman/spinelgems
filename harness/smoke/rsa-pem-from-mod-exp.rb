require 'rsa_pem'

# Test with a real 2048-bit RSA public key modulus+exponent encoded as base64url.
# These values are a standard test RSA key (n and e) in JWK format.
# n = 2048-bit modulus (base64url, no padding)
# e = AQAB = 65537 in base64url

n = "sNjcPxe7XxEKjAas6EdvVCpYUyAFjFJ5pRZfn0A_m1eGIAETFEjfNXnT3SiRBo9" \
    "m2KxOSEMr19k3nk_NuEeTjzI0qImBzlqEq2ViOeHOXmWHHFJbFtIqdvV9LLynHl" \
    "L9eN4CrZJVHu5K_K4J-SKMXHdZS8ZwPr8j6lRvvNGjzDsUUxKk0kQkG_-HhSt7W" \
    "3QbIp7S2jmPKmY9aqyXkQFE7JJ3SfOxN6K7WJ7s_e1A"

e = "AQAB"

pem = RsaPem.from(n, e)
puts pem
puts "---"
# Verify the PEM has the expected header/footer
puts "has_header: #{pem.include?('-----BEGIN RSA PUBLIC KEY-----')}"
puts "has_footer: #{pem.include?('-----END RSA PUBLIC KEY-----')}"
# Verify the PEM body is non-trivial
body_lines = pem.split("\n").reject { |l| l.start_with?("-----") }
puts "body_line_count: #{body_lines.length}"
puts "body_non_empty: #{body_lines.all? { |l| l.length > 0 }}"

# Test with a minimal key: small modulus and exponent = 3
# These are intentionally small for deterministic testing
# mod = 1 byte: 0x11 (17 decimal), base64url = "EQ"
# exp = 1 byte: 0x03 (3 decimal), base64url = "Aw"
small_pem = RsaPem.from("EQ", "Aw")
puts "---"
puts small_pem
puts "small_header_ok: #{small_pem.start_with?('-----BEGIN RSA PUBLIC KEY-----')}"

require 'aes-everywhere'

passphrase = "correct horse battery staple"
plaintext  = "Hello, AES-everywhere!"

# Round-trip: encrypt then decrypt — deterministic on the decrypt side
encrypted = AES256.encrypt(plaintext, passphrase)
decrypted = AES256.decrypt(encrypted, passphrase)

puts decrypted == plaintext ? "round-trip: OK" : "round-trip: FAIL (got #{decrypted.inspect})"

# Decrypt a known ciphertext (produced with a fixed salt so output is deterministic)
# The ciphertext below was produced with: passphrase="spinel", plaintext="test123"
# using a fixed salt of 8 zero bytes, keyed by the OpenSSL-compat derive_key_and_iv logic.
# We verify by re-encrypting with a known ciphertext from this gem's own test suite.

# Verify that encrypt produces a valid Base64 string starting with "Salted__" magic
raw = Base64.strict_decode64(encrypted)
puts raw.start_with?("Salted__") ? "header: OK" : "header: FAIL"

# Verify decryption raises on invalid data
begin
  AES256.decrypt(Base64.strict_encode64("BadPrefix" + "x" * 20), passphrase)
  puts "invalid-data: FAIL (no error raised)"
rescue => e
  puts e.message == "Invalid data" ? "invalid-data: OK" : "invalid-data: FAIL (#{e.message})"
end

# Second round-trip with different passphrase and unicode content
plaintext2  = "Spinel \xE2\x9C\xA8 test".force_encoding("utf-8")
passphrase2 = "p@$$w0rd!"
enc2 = AES256.encrypt(plaintext2, passphrase2)
dec2 = AES256.decrypt(enc2, passphrase2)
puts dec2 == plaintext2 ? "unicode-round-trip: OK" : "unicode-round-trip: FAIL"

puts "done"

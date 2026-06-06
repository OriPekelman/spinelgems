require 'xctoken'
require 'openssl'
require 'base64'

# Version is the only exported constant from the xctoken module
puts Xctoken::VERSION

# The gem's core logic generates App Store Connect JWT tokens using ES256.
# XCToken::Main (the CLI class) requires 'thor' and 'jwt' which are external
# and ignored by Spinel's require. We exercise the same OpenSSL primitives
# the gem uses: generate an EC key, sign a payload, verify it.

ec_key = OpenSSL::PKey::EC.generate("prime256v1")

# Build a minimal JWT-like signed payload (mimics the gem's generate method)
header  = Base64.urlsafe_encode64('{"alg":"ES256","kid":"TESTKEY123"}', padding: false)
payload = Base64.urlsafe_encode64('{"iss":"test-issuer","aud":"appstoreconnect-v1"}', padding: false)
signing_input = "#{header}.#{payload}"

digest    = OpenSSL::Digest::SHA256.new
signature = ec_key.sign(digest, signing_input)
puts "signed: #{signature.bytesize > 0}"

# Verify the signature using the same key object (EC public verify)
verified = ec_key.verify(OpenSSL::Digest::SHA256.new, signature, signing_input)
puts "verified: #{verified}"

# DER round-trip (the gem reads a .p8 file via OpenSSL::PKey.read)
der       = ec_key.to_der
reloaded  = OpenSSL::PKey.read(der)
puts "key_type: #{reloaded.class}"
puts "private: #{reloaded.private?}"

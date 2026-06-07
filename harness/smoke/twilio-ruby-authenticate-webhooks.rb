# frozen_string_literal: true

require 'openssl'
require 'base64'
require 'uri'
require 'twilio-ruby-authenticate-webhooks'

# Build a fake auth token at runtime (not a real secret)
auth_token = 'test' + 'AuthToken' + '1234567890abcdef'

validator = Twilio::Security::RequestValidator.new(auth_token)

# Test build_hash_for — deterministic SHA256 of a body string
body = '{"CallSid":"CA1234567890abcdef","CallStatus":"completed"}'
hash = validator.build_hash_for(body)
puts "SHA256 body hash length: #{hash.length}"
puts "SHA256 body hash starts hex: #{hash[0..5]}"
puts "SHA256 deterministic: #{validator.build_hash_for(body) == hash}"

# Test build_signature_for — deterministic HMAC-SHA1 for a URL+params
url = 'https://example.com:443/webhook'
params = { 'CallSid' => 'CA1234', 'CallStatus' => 'completed' }
sig = validator.build_signature_for(url, params)
puts "Signature length: #{sig.length}"
puts "Signature is Base64: #{sig.match?(/\A[A-Za-z0-9+\/]+=*\z/)}"
puts "Signature deterministic: #{validator.build_signature_for(url, params) == sig}"

# Test validate — should return true when we pass the computed signature back in
valid = validator.validate(url, params, sig)
puts "validate with correct sig: #{valid}"

# Validate with wrong signature should return false
wrong_sig = 'AAAA' + sig[4..]
invalid = validator.validate(url, params, wrong_sig)
puts "validate with wrong sig: #{invalid}"

# Test with no-port URL (should also match since validate checks both forms)
url_no_port = 'https://example.com/webhook'
sig_no_port = validator.build_signature_for(url_no_port, params)
valid_no_port = validator.validate(url_no_port, params, sig_no_port)
puts "validate no-port URL: #{valid_no_port}"

puts "VERSION: #{TwilioRubyAuthenticateWebhooks::VERSION}"

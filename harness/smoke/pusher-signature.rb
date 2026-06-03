require 'pusher-signature'

# 1. Token creation
token = Pusher::Signature::Token.new('key123', 'secret456')
puts token.key
puts token.secret

# 2. QueryEncoder: encode a simple param
puts Pusher::Signature::QueryEncoder.encode_param_without_escaping('foo', 'bar')

# 3. Sign a request and verify the auth_hash structure
req = Pusher::Signature::Request.new('GET', '/path/to/resource', { 'channel' => 'test', 'count' => '5' })
auth = token.sign(req)
puts auth[:auth_key]
puts auth[:auth_version]
# Signature is a 64-char lowercase hex string (SHA256 HMAC)
sig = auth[:auth_signature]
puts sig.length
puts sig.match?(/\A[0-9a-f]{64}\z/)

# 4. Authenticate a pre-signed request (round-trip)
ts = auth[:auth_timestamp]
signed_req = Pusher::Signature::Request.new('GET', '/path/to/resource', {
  'channel'        => 'test',
  'count'          => '5',
  'auth_key'       => auth[:auth_key],
  'auth_version'   => auth[:auth_version],
  'auth_timestamp' => ts,
  'auth_signature' => sig
})
result = signed_req.authenticate_by_token(token)
puts result

# 5. authenticate_by_token returns false for wrong secret
bad_token = Pusher::Signature::Token.new('key123', 'wrongsecret')
puts signed_req.authenticate_by_token(bad_token)

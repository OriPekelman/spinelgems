# frozen_string_literal: true

# amadeus-discover smoke — exercises pure-Ruby logic without faraday (not available).
# Config (class-variable getters/setters), Authenticator::Response (Hashie::Dash),
# Authenticator::Credentials (Hashie::Dash), Authenticator::Token (Forwardable + valid?).
# All classes loaded via the entrypoint's autoload chain; no plain require needed here.

require 'amadeus_discover'

# 1. VERSION constant
puts AmadeusDiscover::VERSION

# 2. Config: set and read credentials hash
AmadeusDiscover::Config.credentials = {
  username: 'smoke_user',
  password: 'smoke_pass',
  client_id: 'content-partner-api',
  grant_type: 'password'
}
c = AmadeusDiscover::Config.credentials
puts c[:username]
puts c[:client_id]
puts AmadeusDiscover::Config.connection.nil?

# Reset
AmadeusDiscover::Config.credentials = {}
puts AmadeusDiscover::Config.credentials.empty?

# 3. Authenticator::Response (Hashie::Dash)
resp = AmadeusDiscover::Authenticator::Response.new(
  'access_token' => 'fake_bearer_xyz',
  'expires_in' => 7200
)
puts resp.access_token
puts resp.expires_in

# 4. Authenticator::Credentials (Hashie::Dash with indifferent access)
creds = AmadeusDiscover::Authenticator::Credentials.new(
  username: 'api_user',
  password: 'api_pass',
  client_id: 'partner-api',
  grant_type: 'password'
)
puts creds.username
puts creds.client_id
keys = creds.to_hash.keys.sort
puts keys.length
puts keys.include?('username')

# 5. Authenticator::Token: value delegation + valid? logic
issued_recently = Time.now - 10
tok_valid = AmadeusDiscover::Authenticator::Token.new(
  { 'access_token' => 'tok_abc', 'expires_in' => 3600 },
  issued_recently
)
puts tok_valid.value
puts tok_valid.valid?

# Token that expired 5 seconds ago
issued_old = Time.now - 3700
tok_expired = AmadeusDiscover::Authenticator::Token.new(
  { 'access_token' => 'tok_def', 'expires_in' => 3600 },
  issued_old
)
puts tok_expired.value
puts tok_expired.valid?

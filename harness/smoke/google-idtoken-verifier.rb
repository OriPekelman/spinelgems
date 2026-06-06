# frozen_string_literal: true

require 'google-idtoken-verifier'

# VERSION constant
puts Google::Idtoken::Verifier::VERSION

# ENDPOINT constant in Client
puts Google::Idtoken::Verifier::Client::ENDPOINT

# Result#valid? with a hash that has 'sub' (valid token data)
valid_data = { "sub" => "1234567890", "aud" => "my-app-client-id", "email" => "user@example.com" }
result = Google::Idtoken::Verifier::Result.new(valid_data)
p result.valid?
puts result.data["sub"]
puts result.data["aud"]

# Result#valid? with nil data (invalid)
invalid_result = Google::Idtoken::Verifier::Result.new(nil)
p invalid_result.valid?

# Result#valid? with data missing 'sub' (invalid)
no_sub_result = Google::Idtoken::Verifier::Result.new({ "aud" => "my-app" })
p no_sub_result.valid?

# Client initialization stores the id_token
client = Google::Idtoken::Verifier::Client.new("fake.token.here")
puts client.id_token

# Error is a subclass of StandardError
p Google::Idtoken::Verifier::Error.ancestors.include?(StandardError)

# Error can be raised and rescued
begin
  raise Google::Idtoken::Verifier::Error, "test error message"
rescue Google::Idtoken::Verifier::Error => e
  puts e.message
end

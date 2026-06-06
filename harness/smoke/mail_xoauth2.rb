# frozen_string_literal: true
# Smoke: mail_xoauth2 — exercises Oauth2String#build_oauth2_string and
# ImapXoauth2Authenticator#process without any live network connections.

require 'mail_xoauth2'

# 1. Build an OAuth2 string directly via Oauth2String included in
#    ImapXoauth2Authenticator (public interface: process)
auth = MailXoauth2::ImapXoauth2Authenticator.new(
  'user@example.com',
  'ya29.example_token'
)
result = auth.process(nil)
puts result.inspect

# 2. Verify the format matches the XOAuth2 spec:
#    "user=<email>\x01auth=Bearer <token>\x01\x01"
expected = "user=user@example.com\x01auth=Bearer ya29.example_token\x01\x01"
puts (result == expected).inspect

# 3. Test with a different user/token pair
auth2 = MailXoauth2::ImapXoauth2Authenticator.new(
  'alice@gmail.com',
  'token_abc123'
)
result2 = auth2.process(nil)
puts result2.inspect

# 4. Confirm encoding is ASCII
puts result.encoding.to_s

# 5. Confirm module exists
puts MailXoauth2::ImapXoauth2Authenticator.name

# Smoke test for aws-sigv2 — exercises Aws::Sigv2::Credentials only (no openssl/uri)

creds = Aws::Sigv2::Credentials.new(
  access_key_id: 'AKIDEXAMPLE',
  secret_access_key: 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY'
)
puts creds.access_key_id
puts creds.secret_access_key
puts creds.session_token.nil?

creds2 = Aws::Sigv2::Credentials.new(
  access_key_id: 'AKID2',
  secret_access_key: 'SECRET2',
  session_token: 'TOKEN2'
)
puts creds2.access_key_id
puts creds2.session_token

provider = Aws::Sigv2::StaticCredentialsProvider.new(
  access_key_id: 'AKID3',
  secret_access_key: 'SECRET3'
)
puts provider.credentials.access_key_id
puts provider.credentials.session_token.nil?

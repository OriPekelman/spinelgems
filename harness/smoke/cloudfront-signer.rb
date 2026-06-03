require 'cloudfront-signer'
require 'openssl'

# Generate a fresh RSA key for signing (no filesystem/network needed)
rsa_key = OpenSSL::PKey::RSA.generate(2048)
pem     = rsa_key.to_pem

# Configure the signer directly via the key= setter (avoids key_path file I/O)
Aws::CF::Signer.key          = pem
Aws::CF::Signer.key_pair_id  = 'APKAXXYYZZ12345'
Aws::CF::Signer.default_expires = 3600

puts "version: #{Aws::CF::VERSION}"
puts "configured: #{Aws::CF::Signer.is_configured?}"

# Use a fixed epoch so the policy JSON is deterministic enough to inspect.
fixed_epoch = 1_700_000_000   # 2023-11-14T22:13:20Z

# signed_params with canned policy (expires is an Integer → canned branch)
params = Aws::CF::Signer.signed_params(
  'https://d1234.cloudfront.net/video.mp4',
  expires: fixed_epoch
)

puts "params keys: #{params.keys.sort.join(', ')}"
puts "Expires: #{params['Expires']}"
puts "Key-Pair-Id: #{params['Key-Pair-Id']}"

# Signature must be a non-empty Base64url-ish string (no +/=/)
sig = params['Signature']
puts "signature present: #{!sig.nil? && sig.length > 10}"
puts "signature url-safe: #{sig !~ /[+\/=]/}"

# signed_params with custom policy (ip_range forces custom branch)
custom_params = Aws::CF::Signer.signed_params(
  'https://d1234.cloudfront.net/video.mp4',
  expires: fixed_epoch,
  ip_range: '203.0.113.0/24'
)
puts "custom keys: #{custom_params.keys.sort.join(', ')}"
puts "custom has Policy (not Expires): #{custom_params.key?('Policy') && !custom_params.key?('Expires')}"

# build_url with remove_spaces option
url = Aws::CF::Signer.build_url(
  'https://d1234.cloudfront.net/video.mp4',
  { remove_spaces: true },
  { expires: fixed_epoch }
)
puts "url starts correctly: #{url.start_with?('https://d1234.cloudfront.net/video.mp4?')}"
puts "url contains Expires: #{url.include?('Expires=')}"

# html-escaped variant
safe_url = Aws::CF::Signer.sign_url_safe(
  'https://d1234.cloudfront.net/video.mp4',
  expires: fixed_epoch
)
puts "safe_url has no bare ?: #{!safe_url.include?('?')}"
puts "safe_url html-escaped ?: #{safe_url.include?('%3F')}"

require 'awsraw'
require 'awsraw/s3/configuration'
require 'awsraw/s3/signer'
require 'awsraw/s3/query_string_signer'

# ── 1. Configuration defaults ───────────────────────────────────────────────
cfg = AWSRaw::S3::Configuration.new
puts cfg.host
puts cfg.regional_hosts["us-west-2"]
puts cfg.regional_hosts["eu-west-1"]

# ── 2. Signer — string_to_sign via a minimal struct ─────────────────────────
# Build a fake request object with the fields Signer expects
FakeRequest = Struct.new(:method, :host, :path, :query, :headers)

req = FakeRequest.new(
  "GET",
  "mybucket.s3.amazonaws.com",
  "/mybucket/my/key.txt",
  nil,
  {
    "Date"         => "Tue, 27 Mar 2007 19:36:42 +0000",
    "Content-Type" => "text/plain"
  }
)

access_key = "AKI" + "AIOSFODNN7EXAMPLE"
secret_key  = "wJalrXUtnFEMI/" + "K7MDENG/bPxRfiCYEXAMPLEKEY"
signer = AWSRaw::S3::Signer.new(access_key, secret_key)

sts = signer.string_to_sign(req)
puts sts.gsub("\n", "|")

auth = signer.authorization_header_value(req)
# Print just the prefix so we confirm structure without leaking the signature
puts auth.start_with?("AWS #{access_key}:") ? "auth_ok" : "auth_bad"

# ── 3. QueryStringSigner — deterministic encoded_signature ──────────────────
qs_signer = AWSRaw::S3::QueryStringSigner.new(access_key, secret_key)
sig = qs_signer.encoded_signature("GET\n\n\n1175139620\n/johnsmith/photos/puppy.jpg")
puts sig.length > 10 ? "sig_length_ok" : "sig_length_bad"
puts sig =~ /\A[A-Za-z0-9+\/=]+\z/ ? "sig_chars_ok" : "sig_chars_bad"

# frozen_string_literal: true
# Smoke test for svix gem — exercises Webhook signing and model serialization/deserialization.
require 'svix'

# 1. Webhook#sign — deterministic HMAC signing.
# Build a throwaway test key at runtime so no secret-shaped literal lives in
# the source (the previous hard-coded value was Svix's public docs sample, but
# it still tripped GitHub's whsec_ secret scanner). svix base64-decodes the
# part after the whsec_ prefix.
require "base64"
secret = "whsec_" + Base64.strict_encode64("spinelgems-svix-smoke-not-a-real-key")
wh = Svix::Webhook.new(secret)

msg_id  = "msg_p5jXN8AQM9LWM0D4loKWxJek"
ts      = "1614265330"
payload = '{"test":2432232314}'

sig = wh.sign(msg_id, ts, payload)
puts "sign: #{sig}"

# 2. Verify a known-good signature (bypass timestamp check by faking headers + re-sign)
headers = {
  "svix-id"        => msg_id,
  "svix-timestamp" => ts,
  "svix-signature" => sig
}

# Build headers with current timestamp so verify_timestamp passes
current_ts = Time.now.to_i.to_s
sig2 = wh.sign(msg_id, current_ts, payload)
headers2 = {
  "svix-id"        => msg_id,
  "svix-timestamp" => current_ts,
  "svix-signature" => sig2
}
result = wh.verify(payload, headers2)
puts "verify: #{result[:test]}"

# 3. ApplicationIn model — construct, serialize, to_json round-trip
app = Svix::ApplicationIn.new("name" => "my-app", "uid" => "app_123", "rate_limit" => 100)
serialized = app.serialize
puts "app_name: #{serialized['name']}"
puts "app_uid: #{serialized['uid']}"
puts "app_rate_limit: #{serialized['rateLimit']}"

json_str = app.to_json
roundtrip = Svix::ApplicationIn.deserialize(JSON.parse(json_str))
puts "roundtrip_name: #{roundtrip.name}"
puts "roundtrip_uid: #{roundtrip.uid}"

# 4. EndpointIn model — serialize with camelCase key mapping
ep = Svix::EndpointIn.new(
  "url"          => "https://example.com/webhook",
  "filter_types" => ["user.created", "user.updated"],
  "disabled"     => false,
  "description"  => "test endpoint"
)
ep_serialized = ep.serialize
puts "ep_url: #{ep_serialized['url']}"
puts "ep_filter_types: #{ep_serialized['filterTypes'].sort.join(',')}"
puts "ep_disabled: #{ep_serialized['disabled']}"

# 5. secure_compare utility
puts "secure_cmp_equal: #{Svix.secure_compare('hello', 'hello')}"
puts "secure_cmp_diff: #{Svix.secure_compare('hello', 'world')}"

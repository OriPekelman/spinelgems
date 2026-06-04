# frozen_string_literal: true
# Smoke: stream-chat-ruby
# Exercises: Client#create_token (JWT generation), Client#verify_webhook (HMAC-SHA256),
#             StreamChat.get_sort_fields (sort normalisation), StreamChat.normalize_timestamp
# All logic is pure-Ruby / stdlib; no network calls.

# Bootstrap dependency gems from the spinel-compat cache so this smoke is
# self-contained under the verifier (which gives only -I gem/lib). The BEGIN
# block runs before any require_relative in the assembled harness, ensuring
# sorbet-runtime, faraday, jwt, etc. are on $LOAD_PATH before the gem loads.
BEGIN {
  gem_cache = File.expand_path("~/.cache/spinel-compat/gems")
  if Dir.exist?(gem_cache)
    %w[
      sorbet-runtime-0.6.13256
      faraday-2.14.2
      faraday-net_http-3.4.3
      faraday-multipart-1.2.0
      faraday-net_http_persistent-2.3.1
      net-http-persistent-4.0.8
      multipart-post-2.4.1
      jwt-3.2.0
      connection_pool-3.0.2
    ].each do |gem_dir|
      lib = File.join(gem_cache, gem_dir, "lib")
      $LOAD_PATH.unshift(lib) if Dir.exist?(lib) && !$LOAD_PATH.include?(lib)
    end
  end
}

require "stream-chat"
require "json"
require "base64"
require "openssl"

# --- helpers -----------------------------------------------------------------

def decode_jwt_part(s)
  # JWT uses base64url without padding; restore it
  pad = (4 - s.length % 4) % 4
  JSON.parse(Base64.urlsafe_decode64(s + "=" * pad))
end

# --- 1. VERSION constant ------------------------------------------------------
puts StreamChat::VERSION

# --- 2. Client#create_token — HS256 JWT generation ---------------------------
client = StreamChat::Client.new("myappkey", "x" * 32)

token = client.create_token("user42")
parts = token.split(".")
puts parts.length          # 3 (header.payload.signature)

header  = decode_jwt_part(parts[0])
payload = decode_jwt_part(parts[1])
puts header["alg"]         # HS256
puts payload["user_id"]    # user42

# Token with expiry: payload must carry the exp claim
exp_epoch = 9_999_999_999
tok_exp   = client.create_token("alice", exp_epoch)
pay_exp   = decode_jwt_part(tok_exp.split(".")[1])
puts pay_exp["user_id"]    # alice
puts pay_exp["exp"]        # 9999999999

# --- 3. Client#verify_webhook — HMAC-SHA256 signature check ------------------
body = '{"event":"message.new","channel_id":"general"}'
sig  = OpenSSL::HMAC.hexdigest("SHA256", "x" * 32, body)
puts client.verify_webhook(body, sig)      # true
puts client.verify_webhook(body, "badhex") # false

# --- 4. StreamChat.get_sort_fields — hash → sort-array normalisation ---------
sort = StreamChat.get_sort_fields({ "created_at" => -1, "id" => 1 })
sort.each { |s| puts s[:field] + ":" + s[:direction].to_s }
# created_at:-1
# id:1

puts StreamChat.get_sort_fields(nil).length  # 0 (nil → empty array)

# --- 5. StreamChat.normalize_timestamp — string pass-through + Time→iso8601 --
puts StreamChat.normalize_timestamp("2024-06-01T12:00:00Z")

t = Time.new(2024, 6, 1, 12, 0, 0, 0)
puts StreamChat.normalize_timestamp(t)

# Smoke test for mastercard_api_core
# Exercises: SmartMap dotted-key traversal, RequestMap.setAll, Config class vars,
#            Util URL/hash helpers + sha256 encoding, Environment constants.
# No network, no filesystem, no OAuth (needs PKCS12 file).

require 'mastercard_api_core'

# ── 1. SmartMap: dotted-key set/get/containsKeys ──────────────────────────────
sm = MasterCard::Core::Model::SmartMap.new
sm.set("user.name.first", "Alice")
sm.set("user.name.last",  "Smith")
sm.set("user.age",        30)

puts sm.get("user.name.first")    # => Alice
puts sm.get("user.name.last")     # => Smith
puts sm.get("user.age")           # => 30
puts sm.get("user.name.missing").nil?   # => true
puts sm.containsKeys("user.name.first") # => true
puts sm.containsKeys("user.nope")       # => false
puts sm.size                            # => 1 (top-level key "user")

# ── 2. SmartMap: array / list keys ────────────────────────────────────────────
sm2 = MasterCard::Core::Model::SmartMap.new
sm2.set("items[0]", "alpha")
sm2.set("items[1]", "beta")
puts sm2.get("items[0]")  # => alpha
puts sm2.get("items[1]")  # => beta

# ── 3. RequestMap.setAll from nested Hash ─────────────────────────────────────
rm = MasterCard::Core::Model::RequestMap.new
rm.setAll({"country" => {"code" => "US", "name" => "United States"}, "zip" => "10001"})
puts rm.get("country.code")  # => US
puts rm.get("country.name")  # => United States
puts rm.get("zip")           # => 10001

# ── 4. RequestMap.setAll from Array ───────────────────────────────────────────
rm2 = MasterCard::Core::Model::RequestMap.new
rm2.setAll(["one", "two", "three"])
puts rm2.get("list[0]")  # => one
puts rm2.get("list[2]")  # => three

# ── 5. Config class-variable accessors ────────────────────────────────────────
MasterCard::Core::Config.setDebug(true)
puts MasterCard::Core::Config.isDebug     # => true
MasterCard::Core::Config.setDebug(false)
puts MasterCard::Core::Config.isDebug     # => false

MasterCard::Core::Config.setConnectionTimeout(10)
puts MasterCard::Core::Config.getConnectionTimeout  # => 10
MasterCard::Core::Config.setReadTimeout(60)
puts MasterCard::Core::Config.getReadTimeout        # => 60

# isSandbox default
puts MasterCard::Core::Config.isSandbox  # => true  (default env = SANDBOX)

# ── 6. Util: URL helpers ──────────────────────────────────────────────────────
include MasterCard::Core::Util

puts normalizeUrl("https://sandbox.api.mastercard.com/v1/cards?foo=bar&baz=1")
# => https://sandbox.api.mastercard.com/v1/cards

params = normalizeParams("https://api.example.com/v1?b=2", {"a" => "1"})
puts params  # => a=1&b=2  (lexicographically sorted)

# ── 7. Util: sha256 base64 encode (deterministic on fixed input) ───────────────
puts sha256Base64Encode("hello")  # => LPJNul+wow4m6DsqxbninhsWHlwfp0JecwQzYpOLmCQ=
puts sha1Base64Encode("hello")    # => qvTGHdzF6KLavt4PO0gs2a6pQ00=
puts base64Encode("mastercard")   # => bWFzdGVyY2FyZA==

# ── 8. Util: subMap + getReplacedPath ─────────────────────────────────────────
input = {"id" => "42", "name" => "widget", "color" => "blue"}
extracted = subMap(input, ["id", "color"])
puts extracted.sort.map { |k,v| "#{k}=#{v}" }.join(",")  # => color=blue,id=42
puts input.keys.join(",")  # => name  (extracted keys removed)

path = getReplacedPath("/cards/{card_id}/tokens/{token_id}",
                        {"card_id" => "ABC", "token_id" => "XYZ"})
puts path  # => /cards/ABC/tokens/XYZ

# ── 9. Environment constants ───────────────────────────────────────────────────
puts MasterCard::Core::Environment::SANDBOX     # => sandbox
puts MasterCard::Core::Environment::PRODUCTION  # => production
puts MasterCard::Core::Environment::MAPPING["sandbox"].first
# => https://sandbox.api.mastercard.com

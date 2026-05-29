# Smoke test for cleantalk 0.2.0
# Exercises only the Cleantalk class variable accessor (nil-only, no string assignment)

puts Cleantalk.auth_key.inspect
Cleantalk.auth_key = nil
puts Cleantalk.auth_key.inspect
puts Cleantalk.respond_to?(:auth_key)
puts Cleantalk.respond_to?(:auth_key=)

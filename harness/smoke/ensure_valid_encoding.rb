# Smoke: ensure_valid_encoding - exercises EnsureValidEncoding module API

# Valid UTF-8 string should pass through unchanged
s1 = "hello world"
result1 = EnsureValidEncoding.ensure_valid_encoding(s1)
puts result1

# Invalid byte sequence with :invalid => :replace should replace bad bytes
bad = "\xFF\xFE".force_encoding("UTF-8")
result2 = EnsureValidEncoding.ensure_valid_encoding(bad, invalid: :replace, replace: "?")
puts result2

# Empty string should work
result3 = EnsureValidEncoding.ensure_valid_encoding("")
puts result3.length

# nil check via bang method
result4 = EnsureValidEncoding.ensure_valid_encoding!(nil)
puts result4.inspect

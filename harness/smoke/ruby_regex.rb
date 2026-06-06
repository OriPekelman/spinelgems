require 'ruby_regex'

# Test Username
puts RubyRegex::Username.match?("alice_123")       # true
puts RubyRegex::Username.match?("bad user!")        # false

# Test Email
puts RubyRegex::Email.match?("user@example.com")   # true
puts RubyRegex::Email.match?("not-an-email")        # false

# Test UUID
puts RubyRegex::UUID.match?("550e8400-e29b-41d4-a716-446655440000") # true
puts RubyRegex::UUID.match?("not-a-uuid")           # false

# Test CreditCard
puts RubyRegex::CreditCard.match?("4111-1111-1111-1111") # true
puts RubyRegex::CreditCard.match?("1234")               # false

# Test MacAddress
puts RubyRegex::MacAddress.match?("00:1A:2B:3C:4D:5E") # true
puts RubyRegex::MacAddress.match?("ZZ:ZZ:ZZ:ZZ:ZZ:ZZ") # false

# Test URL
puts RubyRegex::URL.match?("https://www.example.com") # true
puts RubyRegex::URL.match?("not a url")               # false

# Test DBDate
puts RubyRegex::DBDate.match?("2024-06-15") # true
puts RubyRegex::DBDate.match?("2024-13-01") # false

# Test USSocialSecurity
puts RubyRegex::USSocialSecurity.match?("123-45-6789") # true
puts RubyRegex::USSocialSecurity.match?("12-345-6789") # false

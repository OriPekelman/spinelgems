require 'slowweb'

# Exercise SlowWeb limit management API (no network needed)

# 1. Set limits for two hosts
limit1 = SlowWeb.limit('example.com', 5, 60)
limit2 = SlowWeb.limit('api.example.com', 10, 30)

puts limit1.host
puts limit1.count
puts limit1.period
puts limit2.host
puts limit2.count
puts limit2.period

# 2. Retrieve limits by host
retrieved = SlowWeb.get_limit('example.com')
puts retrieved.host
puts retrieved.count == 5

# 3. Check that no limit is exceeded initially
puts SlowWeb.limit_exceeded?('example.com')
puts limit1.exceeded?
puts limit1.current_request_count

# 4. Add mock requests (just pass a symbol as a placeholder object)
limit1.add_request(:req1)
limit1.add_request(:req2)
limit1.add_request(:req3)
puts limit1.current_request_count
puts limit1.exceeded?

# 5. Add enough requests to exceed the limit
limit1.add_request(:req4)
limit1.add_request(:req5)
puts limit1.current_request_count
puts limit1.exceeded?
puts SlowWeb.limit_exceeded?('example.com')

# 6. get_limit for unknown host returns nil
puts SlowWeb.get_limit('unknown.host').nil?
puts SlowWeb.limit_exceeded?('unknown.host')

# 7. Reset clears all limits
SlowWeb.reset
puts SlowWeb.get_limit('example.com').nil?
puts SlowWeb.limit_exceeded?('example.com')

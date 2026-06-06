require 'kissmetrics'

# Exercise QueryStringHash directly — it's the core non-network logic
qs = Kissmetrics::HttpClient::QueryStringHash.new({
  '_k' => 'testkey123',
  '_p' => 'user@example.com',
  '_n' => 'Signed Up',
  'plan' => 'pro tier'
})
puts qs.to_s

# The to_s output should CGI-escape keys and values
qs2 = Kissmetrics::HttpClient::QueryStringHash.new({
  'a b' => 'c d',
  'x' => 'y&z=1'
})
puts qs2.to_s

# HttpClient stores the api_key correctly
client = Kissmetrics::HttpClient.new('mykeyvalue')
puts client.api_key

# Verify that QueryStringHash to_s includes each key-value pair
qs3 = Kissmetrics::HttpClient::QueryStringHash.new({'foo' => 'bar', 'baz' => 'qux'})
result = qs3.to_s
puts result.include?('foo=bar')
puts result.include?('baz=qux')

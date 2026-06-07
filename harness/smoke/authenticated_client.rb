require 'authenticated_client'

# Test 1: default initialization
client = AuthenticatedClient::Client.new
puts client.verb.inspect          # :post
puts client.parameters.inspect   # {}
puts client.body.inspect          # {}
puts client.token.inspect         # nil
puts client.url.inspect           # nil
puts client.auditing.inspect      # nil

# Test 2: attribute accessors
client.url    = 'https://example.com/api'
client.token  = 'tok_' + 'test123'
client.verb   = :get
client.parameters = { page: 1 }
client.body   = { key: 'value' }

puts client.url
puts client.token
puts client.verb.inspect
puts client.parameters.inspect
puts client.body.inspect

# Test 3: VERSION constant
puts AuthenticatedClient::VERSION

# Test 4: validation raises on bad verb
begin
  c2 = AuthenticatedClient::Client.new
  c2.url = 'https://example.com'
  c2.verb = :delete
  c2.request
  puts "no error raised"
rescue RuntimeError => e
  puts e.message
end

# Test 5: validation raises on invalid url
begin
  c3 = AuthenticatedClient::Client.new
  c3.url = 'not a url at all!!!'
  c3.request
  puts "no error raised"
rescue RuntimeError => e
  puts e.message
end

# Test 6: validation raises when parameters is not a hash
begin
  c4 = AuthenticatedClient::Client.new
  c4.url = 'https://example.com'
  c4.parameters = 'bad'
  c4.request
  puts "no error raised"
rescue RuntimeError => e
  puts e.message
end

# Test 7: validation raises when body is not a hash
begin
  c5 = AuthenticatedClient::Client.new
  c5.url = 'https://example.com'
  c5.body = 42
  c5.request
  puts "no error raised"
rescue RuntimeError => e
  puts e.message
end

puts "done"

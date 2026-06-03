require 'rack-proxy'

# 1. VERSION
puts Rack::Proxy::VERSION

# 2. HOP_BY_HOP_HEADERS - verify key membership
hop = Rack::Proxy::HOP_BY_HOP_HEADERS
puts hop['connection']
puts hop['transfer-encoding']
puts hop['upgrade']
puts hop.key?('accept')
puts hop.size

# 3. Protected class methods via send (no Rack runtime needed)
puts Rack::Proxy.send(:titleize, 'content-type')
puts Rack::Proxy.send(:titleize, 'x-forwarded-for')
puts Rack::Proxy.send(:reconstruct_header_name, 'HTTP_HOST')
puts Rack::Proxy.send(:reconstruct_header_name, 'HTTP_X_CUSTOM_HEADER')

# 4. Proxy constructor: defaults for streaming and read_timeout
proxy = Rack::Proxy.new(nil, {})
# These instance variables should be set per initialize logic
puts proxy.instance_variable_get(:@streaming)
puts proxy.instance_variable_get(:@read_timeout)

# 5. rewrite_env and rewrite_response are identity by default
env = { 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/hello' }
returned_env = proxy.rewrite_env(env)
puts returned_env.equal?(env)

triplet = [200, { 'content-type' => 'text/plain' }, ['hello']]
returned_triplet = proxy.rewrite_response(triplet)
puts returned_triplet.equal?(triplet)
puts returned_triplet[0]

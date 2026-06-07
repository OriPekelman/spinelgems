require 'rack-x_served_by'

# Minimal Rack-like app that returns a simple response
simple_app = lambda do |env|
  [200, {'Content-Type' => 'text/plain'}, ['Hello']]
end

# Test 1: Default behavior - middleware adds X-Served-By header
mw = Rack::XServedBy.new(simple_app, 'testhost.example.com')
puts "hostname: #{mw.hostname}"
puts "HEADER_NAME: #{Rack::XServedBy::HEADER_NAME}"

status, headers, body = mw.call({})
puts "status: #{status}"
puts "X-Served-By: #{headers['X-Served-By']}"
puts "Content-Type: #{headers['Content-Type']}"

# Test 2: Does NOT overwrite existing X-Served-By header
app_with_header = lambda do |env|
  [200, {'X-Served-By' => 'already-set', 'Content-Type' => 'text/html'}, ['OK']]
end

mw2 = Rack::XServedBy.new(app_with_header, 'other-host.example.com')
status2, headers2, body2 = mw2.call({})
puts "existing header preserved: #{headers2['X-Served-By']}"

# Test 3: attr_accessor - hostname can be changed
mw.hostname = 'changed-host.example.com'
status3, headers3, body3 = mw.call({})
puts "after change: #{headers3['X-Served-By']}"

# Test 4: VERSION constant
puts "VERSION: #{Rack::XServedBy::VERSION}"

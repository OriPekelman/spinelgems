require 'rack-accept-default'

# Rack::AcceptDefault is a middleware that sets HTTP_ACCEPT if missing.
# Exercise: middleware wraps a simple app and tests three cases:
#   1. No HTTP_ACCEPT set -> middleware fills in the default
#   2. HTTP_ACCEPT already set -> middleware leaves it untouched
#   3. Custom default provided at construction

inner_app = lambda do |env|
  [200, {}, [env['HTTP_ACCEPT']]]
end

# Case 1: default default ('*/*')
mw_default = Rack::AcceptDefault.new(inner_app)

env_no_accept = {}
status, headers, body = mw_default.call(env_no_accept)
puts "status=#{status}"
puts "body_no_accept=#{body.first}"  # should be */*

# Case 2: HTTP_ACCEPT already present – should NOT be overwritten
env_with_accept = { 'HTTP_ACCEPT' => 'application/json' }
_s, _h, body2 = mw_default.call(env_with_accept)
puts "body_with_accept=#{body2.first}"  # should be application/json

# Case 3: custom default
mw_custom = Rack::AcceptDefault.new(inner_app, 'text/html')
env_empty = {}
_s, _h, body3 = mw_custom.call(env_empty)
puts "body_custom_default=#{body3.first}"  # should be text/html

# Case 4: custom default but HTTP_ACCEPT already set – should not overwrite
env_set = { 'HTTP_ACCEPT' => 'image/png' }
_s, _h, body4 = mw_custom.call(env_set)
puts "body_custom_noop=#{body4.first}"  # should be image/png

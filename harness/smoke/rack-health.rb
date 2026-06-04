require 'rack-health'

# Minimal stub app for testing middleware
stub_app = lambda { |env| [404, {'Content-Type' => 'text/plain'}, ['Not Found']] }

# 1. Default health check path → healthy response
middleware = Rack::Health.new(stub_app)
env_health = {'PATH_INFO' => '/rack_health'}
status, headers, body = middleware.call(env_health)
puts "status: #{status}"
puts "body: #{body.first}"
puts "content-type: #{headers['Content-Type']}"

# 2. Non-health path passes through to underlying app
env_other = {'PATH_INFO' => '/other'}
status2, headers2, body2 = middleware.call(env_other)
puts "passthrough status: #{status2}"
puts "passthrough body: #{body2.first}"

# 3. Custom path and sick_if logic → sick response (503)
sick_middleware = Rack::Health.new(stub_app,
  :path => '/health',
  :sick_if => lambda { true }
)
env_sick = {'PATH_INFO' => '/health'}
status3, _headers3, body3 = sick_middleware.call(env_sick)
puts "sick status: #{status3}"
puts "sick body: #{body3.first}"

# 4. Custom body and status lambdas
custom_middleware = Rack::Health.new(stub_app,
  :path => '/ping',
  :body => lambda { |healthy| healthy ? 'OK' : 'FAIL' },
  :status => lambda { |healthy| healthy ? 200 : 503 }
)
env_ping = {'PATH_INFO' => '/ping'}
status4, _h4, body4 = custom_middleware.call(env_ping)
puts "custom status: #{status4}"
puts "custom body: #{body4.first}"

# frozen_string_literal: true

require 'norobots'

# Test 1: VERSION constant
puts "VERSION: #{Norobots::VERSION}"

# Test 2: Middleware blocks robots.txt when BLOCK_ROBOTS is set
# Simulate a minimal Rack app as a lambda
inner_app = lambda { |env| [200, { 'Content-Type' => 'text/html' }, ['Hello']] }

middleware = Norobots::Middleware.new(inner_app)

# Simulate robots.txt request with BLOCK_ROBOTS set
ENV['BLOCK_ROBOTS'] = '1'
robots_env = { 'PATH_INFO' => '/robots.txt' }
status, headers, body = middleware.call(robots_env)
puts "robots.txt blocked: status=#{status}"
puts "robots.txt blocked: content-type=#{headers['Content-Type']}"
puts "robots.txt blocked: body=#{body.first}"

# Test 3: Normal request passes through even with BLOCK_ROBOTS set
normal_env = { 'PATH_INFO' => '/index.html' }
status2, _headers2, body2 = middleware.call(normal_env)
puts "normal passthrough: status=#{status2}"
puts "normal passthrough: body=#{body2.first}"

# Test 4: robots.txt passes through when BLOCK_ROBOTS is NOT set
ENV.delete('BLOCK_ROBOTS')
status3, _headers3, body3 = middleware.call(robots_env)
puts "robots.txt unblocked: status=#{status3}"
puts "robots.txt unblocked: body=#{body3.first}"

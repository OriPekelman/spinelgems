# frozen_string_literal: true

require 'redis_test'

# Exercise port-derived path helpers with a fixed port via ENV
ENV['TEST_REDIS_PORT'] = '16379'

puts RedisTest::VERSION

puts RedisTest.port
puts RedisTest.server_url
puts RedisTest.db_filename

# loglevel default + writer
puts RedisTest.loglevel
RedisTest.loglevel = 'warning'
puts RedisTest.loglevel

# Path helpers (string manipulation only, no filesystem)
puts RedisTest.cache_path.end_with?('/16379/')
puts RedisTest.pidfile.include?('redis-test-16379.pid')
puts RedisTest.logfile.include?('redis.16379.log')

# configure raises on unknown option
begin
  RedisTest.configure(:unknown_option)
rescue => e
  puts e.message
end

# find_available_port returns a positive integer (uses real socket, no network)
port = RedisTest.find_available_port
puts port.is_a?(Integer) && port > 0

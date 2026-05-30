puts RSpec::RedisHelper::CONFIG[:url]
puts RSpec::RedisHelper::TEST[:url]
puts RSpec::RedisHelper::CONFIG == RSpec::RedisHelper::TEST
puts RSpec::RedisHelper.is_a?(Module)

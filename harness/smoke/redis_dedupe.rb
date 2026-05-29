puts RedisDedupe::Set::SEVEN_DAYS
puts RedisDedupe::Set::DEFAULT_EXPIRES_IN
puts RedisDedupe::Set::SEVEN_DAYS == RedisDedupe::Set::DEFAULT_EXPIRES_IN
puts RedisDedupe.respond_to?(:client)
puts RedisDedupe.respond_to?(:client=)

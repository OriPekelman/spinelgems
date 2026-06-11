require_relative "lib/simple_queues/encoders/identity"

enc = SimpleQueues::IdentityEncoder.new
puts enc.encode("hello")
puts enc.encode("world")
puts enc.decode("hello")
puts enc.decode("42")
puts enc.encode("") == ""
puts enc.encode("test") == enc.decode("test")

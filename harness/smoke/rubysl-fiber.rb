require 'fiber'

# rubysl-fiber is a thin shim over Ruby's built-in Fiber class.
# Smoke exercises Fiber creation, resume/yield, value passing,
# and Fiber#alive? state tracking.

# Basic fiber: yield values back to caller
f = Fiber.new do
  Fiber.yield 1
  Fiber.yield 2
  3
end

puts f.resume   # => 1
puts f.resume   # => 2
puts f.resume   # => 3

# alive? transitions
g = Fiber.new { 42 }
puts g.alive?    # => true
g.resume
puts g.alive?    # => false

# Pass values into fiber via resume
adder = Fiber.new do |first|
  second = Fiber.yield(first + 10)
  second + 20
end

puts adder.resume(5)    # => 15  (first + 10)
puts adder.resume(100)  # => 120 (second + 20)

# VERSION constant from the gem shim
puts RubySL::Fiber::VERSION

# Test Goran::VERSION
puts Goran::VERSION

# Test Goran.serve with a simple block that succeeds
result = Goran.serve(max_tries: 3) { 42 }
puts result

# Test Goran.serve with retry_if: returns the value when condition not met
result2 = Goran.serve(max_tries: 5, retry_if: lambda { |x| x < 0 }) { 7 }
puts result2

# Test Goran.serve with fallback (block always returns truthy, retry_if always false)
result3 = Goran.serve(max_tries: 2, retry_if: lambda { |x| false }, fallback: 99) { "hello" }
puts result3

# Test DoubleFault class is defined
puts Goran::DoubleFault.superclass

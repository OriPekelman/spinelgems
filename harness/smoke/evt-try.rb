require 'try'

# Try.call returns true when block succeeds with no error
result1 = Try.call { 1 + 1 }
puts result1.inspect  # true

# Try.call returns false when a listed error is raised
result2 = Try.call(RuntimeError) { raise RuntimeError, "oops" }
puts result2.inspect  # false

# Try.call re-raises unlisted errors
begin
  Try.call(ArgumentError) { raise RuntimeError, "not caught" }
  puts "unreachable"
rescue RuntimeError => e
  puts e.message  # not caught
end

# Try.call with no error filter: swallows any StandardError, returns false
result4 = Try.call { raise TypeError, "any error" }
puts result4.inspect  # false

# Try.call with multiple error classes listed
result5 = Try.call(ArgumentError, TypeError) { raise TypeError, "type err" }
puts result5.inspect  # false

# Try.call succeeds: returns true
result6 = Try.call(RuntimeError) { 42 }
puts result6.inspect  # true

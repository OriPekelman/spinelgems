require 'rubysl/enumerator'

# The gem wraps Ruby's built-in Enumerator; confirm VERSION constant is present
puts RubySL::Enumerator::VERSION

# each_with_index: enumerate elements with their index
[10, 20, 30].each_with_index { |v, i| puts "#{i}:#{v}" }

# each_slice: iterate over fixed-size chunks
[1, 2, 3, 4, 5].each_slice(2) { |s| puts s.inspect }

# each_cons: sliding window of consecutive elements
[1, 2, 3, 4].each_cons(2) { |c| puts c.inspect }

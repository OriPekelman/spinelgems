require 'string-to-bool'

# Truthy values
puts "true".to_bool.inspect    # => true
puts "t".to_bool.inspect       # => true
puts "yes".to_bool.inspect     # => true
puts "y".to_bool.inspect       # => true
puts "1".to_bool.inspect       # => true
puts "YES".to_bool.inspect     # => true
puts "True".to_bool.inspect    # => true

# Falsy values
puts "false".to_bool.inspect   # => false
puts "f".to_bool.inspect       # => false
puts "no".to_bool.inspect      # => false
puts "n".to_bool.inspect       # => false
puts "0".to_bool.inspect       # => false
puts "".to_bool.inspect        # => false
puts "FALSE".to_bool.inspect   # => false

# Invalid value raises ArgumentError
begin
  "maybe".to_bool
  puts "no error raised"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# Empty string with whitespace returns false
puts "   ".to_bool.inspect     # => false

# frozen_string_literal: true
# Smoke test for get_env gem
# Tests GetEnv.[] and GetEnv.fetch with type coercion behaviour

require 'get_env'

# Set up controlled environment variables
ENV['GE_INT']    = '42'
ENV['GE_FLOAT']  = '3.14'
ENV['GE_TRUE']   = 'true'
ENV['GE_FALSE']  = 'false'
ENV['GE_STRING'] = 'hello'

# Test GetEnv.[] type coercion
puts GetEnv['GE_INT'].inspect       # => 42 (Integer)
puts GetEnv['GE_FLOAT'].inspect     # => 3.14 (Float)
puts GetEnv['GE_TRUE'].inspect      # => true (TrueClass)
puts GetEnv['GE_FALSE'].inspect     # => false (FalseClass)
puts GetEnv['GE_STRING'].inspect    # => "hello" (String)
puts GetEnv[nil].inspect            # => nil

# Test GetEnv.fetch with default
puts GetEnv.fetch('GE_INT', 0).inspect          # => 42
puts GetEnv.fetch('GE_MISSING', 99).inspect     # => 99

# Test GetEnv.fetch with block
puts GetEnv.fetch('GE_TRUE') { 'fallback' }.inspect    # => true
puts GetEnv.fetch('GE_MISSING') { 'fallback' }.inspect # => "fallback"

# Test KeyError raised when key missing and no default/block
begin
  GetEnv.fetch('GE_MISSING')
  puts "no error"
rescue KeyError
  puts "KeyError raised"
end

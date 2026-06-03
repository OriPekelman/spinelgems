require 'optionable'

# Exercise Optionable::Any type-matcher
any_int = Optionable.any(Integer)
puts any_int.inspect        # => "any Integer"
puts(any_int == 42)         # => true
puts(any_int == "hello")    # => false

# Define a class that uses the DSL
class MyOptions
  include Optionable
  option(:mode).allow(:fast, :slow)
  option(:level).allow(1, 2, 3)
  option(:timeout).allow(Optionable.any(Integer))
end

obj = MyOptions.new

# Valid options pass silently
obj.validate_strict(mode: :fast, level: 2)
puts "valid ok"

# any(Integer) allows any integer
obj.validate_strict(timeout: 999)
puts "timeout ok"

# Invalid value raises Optionable::Invalid with a meaningful message
begin
  obj.validate_strict(mode: :bad)
  puts "should not reach"
rescue Optionable::Invalid => e
  puts e.message
end

# Unknown key raises Optionable::Unknown
begin
  obj.validate_strict(unknown_key: 1)
  puts "should not reach"
rescue Optionable::Unknown => e
  puts e.message
end

# Validator key attribute
v = MyOptions.optionable_validators[:mode]
puts v.key.inspect

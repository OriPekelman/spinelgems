# frozen_string_literal: true

require 'typerb'

using Typerb

# type! - valid case: returns self
x = 42
result = x.type!(Integer)
puts "type! Integer ok: #{result}"

# type! - valid multi-class
y = "hello"
result2 = y.type!(Integer, String)
puts "type! String or Integer ok: #{result2}"

# type! - invalid: should raise TypeError
begin
  z = "not an int"
  z.type!(Integer)
  puts "type! ERROR: no exception raised"
rescue TypeError => e
  puts "type! raises TypeError ok: #{e.message.include?('Integer')}"
end

# not_nil! - non-nil returns self
val = "present"
puts "not_nil! ok: #{val.not_nil!}"

# not_nil! - nil raises TypeError
begin
  n = nil
  n.not_nil!
  puts "not_nil! ERROR: no exception raised"
rescue TypeError => e
  puts "not_nil! raises TypeError ok: #{e.message.include?('nil')}"
end

# enum! - value in set
color = :red
puts "enum! ok: #{color.enum!(:red, :green, :blue)}"

# enum! - value not in set raises TypeError
begin
  bad = :purple
  bad.enum!(:red, :green, :blue)
  puts "enum! ERROR: no exception raised"
rescue TypeError => e
  puts "enum! raises TypeError ok: #{e.message.include?('purple') || e.message.include?('one of')}"
end

# respond_to! - object that responds
arr = [1, 2, 3]
puts "respond_to! ok: #{arr.respond_to!(:each, :map).class}"

# respond_to! - object missing method raises TypeError
begin
  num = 99
  num.respond_to!(:nonexistent_method_xyz)
  puts "respond_to! ERROR: no exception raised"
rescue TypeError => e
  puts "respond_to! raises TypeError ok: #{e.message.include?('nonexistent_method_xyz')}"
end

puts "done"

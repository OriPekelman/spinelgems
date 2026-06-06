require 'O_o'

# O_o is a custom exception class (subclass of StandardError).
# Exercises: raise/rescue with message, polymorphic rescue, rescue ordering.

# 1. Raise and rescue O_o by its own type, check message
begin
  raise O_o, "something went wrong"
rescue O_o => e
  puts e.message          # something went wrong
  puts "caught O_o"       # caught O_o
end

# 2. O_o is rescued as StandardError (it's a subclass)
begin
  raise O_o, "also standard"
rescue StandardError => e
  puts e.message          # also standard
  puts "caught as StandardError"
end

# 3. O_o is NOT caught by RuntimeError rescue (wrong branch)
caught_wrong = false
begin
  raise O_o, "test"
rescue RuntimeError
  caught_wrong = true
rescue O_o
  caught_wrong = false
end
puts caught_wrong         # false

# 4. O_o is not an instance of RuntimeError
puts O_o.new.is_a?(StandardError)   # true
puts O_o.new.is_a?(RuntimeError)    # false

puts "done"

require 'O_O'

# O_O is a StandardError subclass — its entire API is raise/rescue

# 1. Class hierarchy
puts O_O.ancestors.include?(StandardError)   # true
puts O_O.ancestors.include?(Exception)       # true
puts O_O.superclass                          # StandardError

# 2. Raise and rescue with default message
begin
  raise O_O
rescue O_O => e
  puts e.class           # O_O
  puts e.is_a?(StandardError)  # true
end

# 3. Raise with a custom message
begin
  raise O_O, "something went wrong"
rescue O_O => e
  puts e.message         # something went wrong
end

# 4. Rescue as StandardError (polymorphism)
caught = false
begin
  raise O_O, "caught as std"
rescue StandardError => e
  caught = true
  puts e.class           # O_O
end
puts caught              # true

# 5. Not caught by RuntimeError rescue
caught_runtime = false
begin
  raise O_O, "not runtime"
rescue RuntimeError
  caught_runtime = true
rescue O_O
  caught_runtime = false
end
puts caught_runtime      # false

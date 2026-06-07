# chickadee smoke — exercises NumericID and UUID value objects
# These classes live entirely in chickadee with no external dependencies.

require 'chickadee/version'
require 'chickadee/vos/numeric_id'
require 'chickadee/vos/uuid'

# VERSION
puts Chickadee::VERSION

# NumericID basics
id1 = Chickadee::NumericID.new(42)
id2 = Chickadee::NumericID.new(7)
id3 = Chickadee::NumericID.new(42)

puts id1.to_i                   # 42
puts id2.to_i                   # 7
puts (id1 == id3)               # true  (same hash)
puts (id1 == id2)               # false
puts (id1 <=> id2)              # 1  (42 > 7)
puts (id2 <=> id1)              # -1
puts [id1, id2, id3].min.to_i  # 7

# NumericID rejects bad input
begin
  Chickadee::NumericID.new(-1)
  puts "no error"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

begin
  Chickadee::NumericID.new("abc")
  puts "no error"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# UUID basics
valid_uuid = "550e8400-e29b-41d4-a716-446655440000"
u1 = Chickadee::UUID.new(valid_uuid)
u2 = Chickadee::UUID.new(valid_uuid)
u3 = Chickadee::UUID.new("6ba7b810-9dad-11d1-80b4-00c04fd430c8")

puts u1.to_s                    # 550e8400-e29b-41d4-a716-446655440000
puts (u1 == u2)                 # true
puts (u1 == u3)                 # false

# UUID rejects bad input
begin
  Chickadee::UUID.new("not-a-uuid")
  puts "no error"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

begin
  Chickadee::UUID.new(12345)
  puts "no error"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

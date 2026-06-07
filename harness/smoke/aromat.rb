require 'aromat'

# 1. Numeric#duration - convert seconds to human-readable duration
puts 3661.duration          # "1 Hour 1 Minute 1 Second"
puts 90061.duration         # "1 Day 1 Hour 1 Minute 1 Second"
puts 90061.duration(2)      # limited to 2 elements

# 2. String#rpad and #lpad - padding
puts "hi".rpad(6)           # "hi    "
puts "hi".lpad(6)           # "    hi"
puts "hello".rpad(3)        # "hel" (truncated)

# 3. String#nstr - non-empty string
puts "".nstr.inspect        # nil
puts "foo".nstr.inspect     # "foo"

# 4. Hash#sym_keys and #str_keys - key conversion
h = { "a" => { "b" => 1 }, "c" => 2 }
puts h.sym_keys.inspect     # {:a=>{:b=>1}, :c=>2}

h2 = { a: { b: 1 }, c: 2 }
puts h2.str_keys.inspect    # {"a"=>{"b"=>1}, "c"=>2}

# 5. Array#sym_keys with nested hashes
arr = [{ "x" => 10 }, { "y" => { "z" => 20 } }]
puts arr.sym_keys.inspect   # [{:x=>10}, {:y=>{:z=>20}}]

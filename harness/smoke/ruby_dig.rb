require 'ruby_dig'

# ruby_dig backfills Hash#dig and Array#dig for Ruby < 2.3.
# On Ruby >= 2.3 the built-in methods are used; RubyDig module is still defined.
# We exercise real dig logic through Hash, Array, and a custom RubyDig includer.

# 1. Hash#dig single key
response = {
  mom:  { first: "Marge", last: "Bouvier" },
  dad:  { first: "Homer", last: "Simpson" },
  kids: [
    { first: "Bart",  last: "Simpson" },
    { first: "Lisa",  last: "Simpson" }
  ]
}

puts response.dig(:dad, :first)           # => Homer
puts response.dig(:kids, 1, :first)       # => Lisa
puts response.dig(:uncle).inspect         # => nil
puts response.dig(:mom, :last)            # => Bouvier

# 2. Array#dig
arr = ["zero", ["ten", "eleven", "twelve"], "two"]
puts arr.dig(1, 2)                        # => twelve
puts arr.dig(5).inspect                   # => nil

# 3. RubyDig module on a custom class
class MyMap
  include RubyDig
  def initialize(h); @h = h; end
  def [](k); @h[k]; end
end

m = MyMap.new(x: MyMap.new(y: 99), z: "hello")
puts m.dig(:x, :y)                        # => 99
puts m.dig(:z)                            # => hello
puts m.dig(:missing).inspect              # => nil

# 4. RubyDig is a Module
puts RubyDig.is_a?(Module)               # => true

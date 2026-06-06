require 'amazon'

# amazon 0.0.1 is a skeleton gem ("Squat") with only a VERSION constant
# and an empty module. There is no public API beyond the module itself.

puts Amazon::VERSION
puts Amazon.class
puts Amazon.is_a?(Module)
puts Amazon.respond_to?(:new)

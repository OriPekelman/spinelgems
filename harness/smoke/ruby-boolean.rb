require 'ruby-boolean'

# Boolean module is mixed into TrueClass and FalseClass.
# Core use-case: is_a?(Boolean) and kind_of?(Boolean) on literal values.
puts true.is_a?(Boolean)    # => true
puts false.is_a?(Boolean)   # => true
puts 42.is_a?(Boolean)      # => false
puts nil.is_a?(Boolean)     # => false
puts "str".is_a?(Boolean)   # => false

# kind_of? is an alias for is_a?
puts true.kind_of?(Boolean)   # => true
puts false.kind_of?(Boolean)  # => true
puts 0.kind_of?(Boolean)      # => false

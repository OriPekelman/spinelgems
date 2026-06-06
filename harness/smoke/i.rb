require 'i'

# The gem defines an empty namespace module with a VERSION constant
puts I.class          # => Module
puts I::VERSION       # => 0.1.0

# Module introspection: ancestors includes itself
puts I.ancestors.include?(I)  # => true

# Include the module into a class
class Foo
  include I
end
puts Foo.ancestors.include?(I)  # => true
puts Foo.new.is_a?(I)           # => true

# Module name
puts I.name  # => I

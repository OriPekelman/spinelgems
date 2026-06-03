require 'metaclass'

# Test __metaclass__ returns singleton class
obj = Object.new
mc = obj.__metaclass__
puts mc.class                                       # => Class
puts mc == obj.singleton_class                      # => true

# metaclass is unique per object
obj2 = Object.new
puts obj.__metaclass__ == obj2.__metaclass__        # => false

# Works on a custom class instance
class Foo
  def bar; "bar"; end
end
foo = Foo.new
puts foo.__metaclass__.class                        # => Class
puts foo.__metaclass__ == foo.singleton_class       # => true

# Works on the class itself (Class is also an Object)
puts Foo.__metaclass__.class                        # => Class
puts Foo.__metaclass__ == Foo.singleton_class       # => true

# Version constant
puts Metaclass::VERSION                             # => 0.0.4

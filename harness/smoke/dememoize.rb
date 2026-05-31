# Smoke test for dememoize gem
# Tests Dememoize module_function methods

# Test remove_instance_variable_if_defined - var not set
obj = Object.new
result = Dememoize.remove_instance_variable_if_defined(obj, :@foo)
puts result.nil?

# Test remove_instance_variable_if_defined - var is set
obj2 = Object.new
obj2.instance_variable_set(:@bar, 42)
puts obj2.instance_variable_defined?(:@bar)
Dememoize.remove_instance_variable_if_defined(obj2, :@bar)
puts obj2.instance_variable_defined?(:@bar)

# Test dememoize with explicit variable names
obj3 = Object.new
obj3.instance_variable_set(:@x, 1)
obj3.instance_variable_set(:@y, 2)
Dememoize.dememoize(obj3, :@x)
puts obj3.instance_variable_defined?(:@x)
puts obj3.instance_variable_defined?(:@y)

# Test dememoize clears specified var
obj4 = Object.new
obj4.instance_variable_set(:@a, "hello")
Dememoize.remove_instance_variable_if_defined(obj4, :@a)
puts obj4.instance_variable_defined?(:@a)

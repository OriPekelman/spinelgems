puts Test::Unit::Assertions.instance_methods(false).sort.inspect
puts Test::Unit::Assertions.is_a?(Module)
puts Test::Unit::Assertions.instance_method(:assert_not).arity
puts Test::Unit::Assertions.instance_method(:assert_greater_than).arity
puts Test::Unit::Assertions.instance_method(:assert_less_than).arity

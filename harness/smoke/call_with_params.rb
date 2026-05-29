include CallWithParams

# call_with_params with no args returns nil
puts call_with_params.inspect

# call_with_params with a non-Proc returns the value directly
puts call_with_params(42)
puts call_with_params("hello")

# call_with_params with a Proc calls it with provided args
double = ->(x) { x * 2 }
puts call_with_params(double, 5)

add = ->(a, b) { a + b }
puts call_with_params(add, 3, 7)

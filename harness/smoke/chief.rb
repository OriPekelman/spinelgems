require 'chief'

# Subclass Command to exercise real logic
class AddNumbers < Chief::Command
  def initialize(a, b)
    @a = a
    @b = b
  end

  def call
    if @a.is_a?(Numeric) && @b.is_a?(Numeric)
      success!(@a + @b)
    else
      fail!(nil, "inputs must be numeric")
    end
  end
end

class DivideNumbers < Chief::Command
  def initialize(a, b)
    @a = a
    @b = b
  end

  def call
    if @b == 0
      fail!(nil, "division by zero")
    else
      success!(@a.to_f / @b)
    end
  end
end

# Test success path via .call
result = AddNumbers.call(3, 4)
puts result.success?         # true
puts result.failure?         # false
puts result.value            # 7
puts result.errors.inspect   # nil

# Test shortcut .value
val = AddNumbers.value(10, 5)
puts val                     # 15

# Test failure path
bad = AddNumbers.call("x", 2)
puts bad.success?            # false
puts bad.failure?            # true
puts bad.value.inspect       # nil
puts bad.errors              # inputs must be numeric

# Test to_ary (destructuring)
result2, v2, e2 = DivideNumbers.call(10, 4)
puts result2.success?        # true
puts v2                      # 2.5
puts e2.inspect              # nil

# Test division by zero
zero_result = DivideNumbers.call(5, 0)
puts zero_result.failure?    # true
puts zero_result.errors      # division by zero

# Test Result directly
r = Chief::Result.new(42, nil)
puts r.value                 # 42
puts r.success?              # true

r2 = Chief::Result.new(false, ["bad"])
puts r2.failure?             # true
puts r2.errors.inspect       # ["bad"]

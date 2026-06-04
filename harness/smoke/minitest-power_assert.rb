require 'minitest-power_assert'

# 1. Version constant
puts Minitest::PowerAssert::VERSION

# 2. Assertions module is defined
puts Minitest::PowerAssert::Assertions.name

# 3. Module exposes assert and refute instance methods
methods = Minitest::PowerAssert::Assertions.instance_methods(false).sort
puts methods.inspect

# 4. Minitest::Test includes PowerAssert::Assertions (assert/refute override)
class SmokeTest < Minitest::Test
  def run_checks
    # assert with a block (power_assert path)
    x = 7
    r1 = assert { x > 3 }
    puts "assert block: #{r1}"

    # assert without a block (super path)
    r2 = assert(42 > 0)
    puts "assert plain: #{r2}"

    # refute with a block
    y = 2
    r3 = refute { y > 100 }
    puts "refute block: #{r3}"

    # refute without a block
    r4 = refute(false)
    puts "refute plain: #{r4}"
  end
end

t = SmokeTest.new('run_checks')
t.run_checks
puts "integration: ok"

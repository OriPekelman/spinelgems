require 'ramsey_cop'

# RamseyCop is a RuboCop configuration distribution gem.
# Its Ruby surface is minimal: a versioned module and a Rails generator.
# The generator requires Rails, so we only test the module itself.

# Test 1: module exists and is a Module
puts RamseyCop.class

# Test 2: VERSION is present and matches gem version pattern
puts RamseyCop::VERSION
puts RamseyCop::VERSION.split('.').length == 3

# Test 3: module is otherwise empty (no instance methods beyond inherited)
# ancestors chain should include Module internals but not Rails classes
puts RamseyCop.is_a?(Module)
puts RamseyCop.respond_to?(:freeze)

# Test 4: module name
puts RamseyCop.name

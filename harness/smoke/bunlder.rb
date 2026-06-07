# smoke: bunlder — stub gem with no public API beyond the module and version constant
require 'bunlder'

# Verify the module exists and version constant is accessible
puts Bunlder::VERSION
puts Bunlder.class
puts Bunlder.is_a?(Module)
puts Bunlder.constants.sort.inspect

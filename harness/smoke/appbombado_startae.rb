require 'appbombado_startae'

# AppbombadoStartae is a Rails generator gem. The main module body is empty;
# all runtime logic lives in AppbombadoGenerator which inherits from
# Rails::Generators::Base (not available without Rails). We exercise what
# IS available: the module identity, the VERSION constant, and module
# introspection that Spinel must handle correctly.

puts AppbombadoStartae::VERSION

# The gem declares one module with no instance methods of its own.
puts AppbombadoStartae.class          # Module
puts AppbombadoStartae.name           # AppbombadoStartae

# Constants defined in the module
constants = AppbombadoStartae.constants.map(&:to_s).sort
puts constants.inspect

# Module inclusion introspection
puts AppbombadoStartae.is_a?(Module)  # true
puts AppbombadoStartae.frozen?        # false — modules are not frozen by default

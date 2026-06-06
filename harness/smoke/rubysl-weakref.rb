require 'rubysl/weakref'

# This gem is a stdlib shim exposing RubySL::WeakRef::VERSION
puts RubySL::WeakRef::VERSION
puts RubySL::WeakRef.is_a?(Module)
puts RubySL::WeakRef.name

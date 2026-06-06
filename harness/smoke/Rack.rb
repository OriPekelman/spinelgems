# Rack-2.0.0 smoke
# This gem (capital-R "Rack") is a joke gem by "bonghits heavy industries".
# lib/Rack.rb is completely empty (0 bytes); no module, class, or constant
# is defined. The only real code lives in bin/Rack (ASCII-art rack printer)
# which uses File.read and rand — not a library API.
#
# We exercise the one observable behaviour: require succeeds and defines nothing.
require 'Rack'

puts defined?(Rack).inspect          # => nil (no constant defined)
puts Kernel.const_defined?(:Rack)    # => false
puts "load ok"

# Cartesian (capitalized) is an obsolete renamed stub of the 'cartesian' gem.
# Its lib/cartesian.rb is empty (0 bytes); all logic lives in the 'cartesian'
# dependency which is a separate gem not available here.
# We can only verify that the require itself is a no-op and produces no errors.
require 'cartesian'

# If we reach here, the require succeeded (or was silently ignored).
# There is no public API in this gem to call.
puts "require completed"
puts "Cartesian stub loaded (no public API)"

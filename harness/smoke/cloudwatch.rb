require 'cloudwatch'

# cloudwatch 0.0.1 is a stub gem with only a VERSION constant and an empty module.
# There is no real public API to exercise — the gem body is literally:
#   module Cloudwatch; end
# We verify the module exists, the VERSION is correct, and basic module identity.

puts Cloudwatch::VERSION
puts Cloudwatch.is_a?(Module)
puts Cloudwatch.name
puts Cloudwatch.instance_methods(false).sort.inspect

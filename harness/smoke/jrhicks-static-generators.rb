require 'static_generators'

# The gem is a Rails generators package; its lib/ exposes only the
# StaticGenerators namespace marker. Verify the module constant is
# present and behaves as a Ruby Module.

puts StaticGenerators.class               # Module
puts StaticGenerators.is_a?(Module)       # true
puts StaticGenerators.name                # StaticGenerators
puts StaticGenerators.ancestors.include?(StaticGenerators)  # true
puts StaticGenerators.instance_methods(false).length        # 0  — intentionally empty

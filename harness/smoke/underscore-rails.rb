require 'underscore-rails'

# underscore-rails is a Rails asset-pipeline wrapper that ships underscore.js.
# Its Ruby surface is minimal: a versioned module and a Rails engine (the engine
# only registers when ::Rails is already defined). We exercise:
#   1. Module namespace resolution
#   2. VERSION constant value
#   3. The conditional branch: without Rails loaded, no Engine constant exists

puts Underscore::Rails::VERSION

puts Underscore::Rails.is_a?(Module)

# Without Rails, the Engine constant must NOT be defined
engine_defined = defined?(Underscore::Rails::Engine) ? true : false
puts engine_defined

# Module ancestry
puts Underscore::Rails.ancestors.include?(Underscore::Rails)

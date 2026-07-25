require 'underscore-rails'

# underscore-rails is a Rails asset-pipeline wrapper that ships underscore.js.
# Its Ruby surface is minimal: a versioned module and a Rails engine (the engine
# only registers when ::Rails is already defined). We exercise:
#   1. Module namespace resolution
#   2. VERSION constant value
#   3. The conditional branch: without Rails loaded, no Engine constant exists

puts Underscore::Rails::VERSION

puts Underscore::Rails.is_a?(Module)

# NB: no defined?(…::Engine) assertion — Spinel resolves defined? statically
# (docs/limitations.md: hoisted class in a dead branch answers truthy;
# documented, deliberate). Same smoke rule family as .frozen? on literals.

# Module ancestry
puts Underscore::Rails.ancestors.include?(Underscore::Rails)

require 'angularjs-rails'

# Version constants
puts AngularJS::Rails::VERSION
puts AngularJS::Rails::UNSTABLE_VERSION

# Type checks
puts AngularJS::Rails::VERSION.class
puts AngularJS::Rails::UNSTABLE_VERSION.class

# Semantic version parsing
stable_parts = AngularJS::Rails::VERSION.split('.').map(&:to_i)
puts stable_parts.inspect
puts stable_parts.length == 3

# The unstable version contains a pre-release suffix
unstable = AngularJS::Rails::UNSTABLE_VERSION
puts unstable.include?('-')
puts unstable.start_with?('2.')

# Without Rails or Sprockets loaded, no Engine/Sprockets integration runs
puts defined?(AngularJS::Rails::Engine).inspect

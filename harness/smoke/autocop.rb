# frozen_string_literal: true

require 'autocop'

# autocop is a RuboCop configuration gem with a minimal Ruby surface.
# Exercise the module constant, VERSION, and basic module introspection.

puts Autocop::VERSION
puts Autocop.class
puts Autocop.is_a?(Module)
puts Autocop.respond_to?(:name)
puts Autocop.name
puts Autocop.ancestors.include?(Autocop)

# Verify the version string format (semver-ish: digits.digits.digits)
version_parts = Autocop::VERSION.split('.').map(&:to_i)
puts version_parts.length
puts version_parts.all? { |p| p >= 0 }
puts version_parts.first >= 0

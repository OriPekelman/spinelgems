# smoke: starter_generators
# The gem is a pure Rails generator library (starter:resource, starter:style).
# All generator classes require rails/generators/active_record at load time,
# which is not available outside Rails. The only loadable code is the top-level
# module + version. We verify the module structure and version string shape,
# which is the complete standalone-loadable API surface.
require 'starter_generators'

v = StarterGenerators::VERSION
# Version must be a dot-separated numeric string
parts = v.split('.')
raise "VERSION not a string" unless v.is_a?(String)
raise "VERSION has no dots" unless parts.length >= 2
raise "VERSION parts not numeric" unless parts.all? { |p| p.match?(/\A\d+\z/) }

puts "version: #{v}"
puts "parts: #{parts.inspect}"
puts "module_name: #{StarterGenerators.name}"
puts "is_module: #{StarterGenerators.is_a?(Module)}"
puts "ancestors: #{StarterGenerators.ancestors.map(&:name).inspect}"

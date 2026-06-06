# smoke: itamae-plugin-recipe-rbenv
# This gem is an itamae DSL plugin. Requiring it loads only the VERSION
# constant; all recipe files (install, user, system, dependency) use itamae
# DSL methods (node, include_recipe, git, package, execute) that are only
# available inside an itamae runner context. No testable public API exists
# without the itamae runtime.
require 'itamae-plugin-recipe-rbenv'

v = Itamae::Plugin::Recipe::Rbenv::VERSION
raise "VERSION missing" unless v.is_a?(String) && !v.empty?

# Verify version format: semantic (X.Y.Z)
parts = v.split('.')
raise "VERSION not semver: #{v}" unless parts.length >= 2 && parts.all? { |p| p.match?(/\A\d+\z/) }

puts "VERSION=#{v}"
puts "major=#{parts[0].to_i}"
puts "minor=#{parts[1].to_i}"

# Module hierarchy check
puts "modules=#{[Itamae, Itamae::Plugin, Itamae::Plugin::Recipe, Itamae::Plugin::Recipe::Rbenv].map(&:name).join(',')}"
puts "constants=#{Itamae::Plugin::Recipe::Rbenv.constants.sort.inspect}"

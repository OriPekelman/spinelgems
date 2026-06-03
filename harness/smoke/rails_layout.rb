# smoke: rails_layout
# The gem is a Rails generator utility; its lib exposes only RailsLayout::VERSION.
# All generator classes require rails/generators (ignored by Spinel). We exercise
# the module structure and version-string semantics — the only standalone logic
# the gem provides outside a Rails application context.

require 'rails_layout'

v = RailsLayout::VERSION

# Verify version format: major.minor.patch
parts = v.split('.')
puts "parts_count=#{parts.length}"
puts "major=#{parts[0].to_i}"
puts "minor=#{parts[1].to_i}"
puts "patch=#{parts[2].to_i}"

# Module identity
puts "module_name=#{RailsLayout.name}"
puts "is_module=#{RailsLayout.is_a?(Module)}"

# Version string properties
puts "version_nonempty=#{!v.empty?}"
puts "version_match=#{v.match?(/\A\d+\.\d+\.\d+\z/)}"

# Numeric version for comparison
numeric = parts.map(&:to_i)
puts "version_ge_1=#{numeric[0] >= 1}"
puts "version_string=#{v}"

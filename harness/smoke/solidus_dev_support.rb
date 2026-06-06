# frozen_string_literal: true

require 'solidus_dev_support'

# 1. VERSION constant and string operations
v_str = SolidusDevSupport::VERSION
parts = v_str.split('.').map(&:to_i)
puts "version: #{v_str}"
puts "major: #{parts[0]}"
puts "minor: #{parts[1]}"
puts "patch: #{parts[2]}"
puts "semver_sum: #{parts.sum}"

# 2. gem_version returns Gem::Version and supports comparison operators
gv = SolidusDevSupport.gem_version
puts "gem_version class: #{gv.class}"
puts "gte 2.0: #{gv >= Gem::Version.new('2.0')}"
puts "lt 3.0: #{gv < Gem::Version.new('3.0')}"
puts "eq self: #{gv == Gem::Version.new(v_str)}"
puts "segments count: #{gv.segments.length}"

# 3. Error subclasses StandardError — verify exception hierarchy
err = SolidusDevSupport::Error.new("something went wrong")
puts "error message: #{err.message}"
puts "is StandardError: #{err.is_a?(StandardError)}"
puts "is RuntimeError: #{err.is_a?(RuntimeError)}"
puts "error class: #{err.class}"

# 4. Gem::Version ordering: current version is between bounds
lower = Gem::Version.new("2.11.0")
upper = Gem::Version.new("2.13.0")
puts "in range: #{gv > lower && gv < upper}"

# 5. Requirement satisfaction (same logic as reset_spree_preferences_deprecated?)
req_gte = Gem::Requirement.new(">= 2.9")
req_lt  = Gem::Requirement.new("< 2.0")
puts "satisfies >=2.9: #{req_gte.satisfied_by?(gv)}"
puts "satisfies <2.0: #{req_lt.satisfied_by?(gv)}"

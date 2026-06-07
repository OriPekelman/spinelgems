# frozen_string_literal: true

# panolint: configuration-only gem for rubocop/brakeman.
# Its entire Ruby API is the VERSION constant in the Panolint module.

require "panolint"

# VERSION is a string
puts Panolint::VERSION.class

# VERSION matches semver pattern
v = Panolint::VERSION
parts = v.split(".")
puts parts.length
puts parts[0].to_i >= 0 ? "major-ok" : "major-bad"
puts parts[1].to_i >= 0 ? "minor-ok" : "minor-bad"

# Version comparison (real logic)
major, minor, patch = v.split(".").map(&:to_i)
puts major
puts minor
puts patch

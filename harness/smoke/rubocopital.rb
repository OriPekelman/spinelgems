# frozen_string_literal: true
# Smoke: rubocopital — RuboCop shared-config gem.
# The gem's entire Ruby API is a VERSION constant and an empty module.
# All real functionality is YAML config files; there is no executable logic.
# We verify the module exists and the version string is well-formed.

require 'rubocopital'

# Module must be defined
puts Rubocopital.class

# VERSION must be a String matching semver shape
v = Rubocopital::VERSION
puts v
puts v.split('.').length >= 2 ? "version_ok" : "version_bad"
puts v =~ /\A\d+\.\d+/ ? "semver_ok" : "semver_bad"

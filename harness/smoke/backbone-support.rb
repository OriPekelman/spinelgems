# backbone-support smoke
# This gem is a Rails Engine asset provider (JavaScript utilities for Backbone.js).
# The Ruby surface is: BackboneSupport module + VERSION constant + Engine (Rails-only).
# We load version.rb directly; the top-level backbone-support.rb gates on Rails.

require 'backbone-support/version'

# VERSION constant exists and is a frozen string
puts BackboneSupport::VERSION
puts BackboneSupport::VERSION.frozen? ? "frozen" : "mutable"

# Module is defined
puts BackboneSupport.is_a?(Module) ? "module_ok" : "module_fail"

# The version string matches semver pattern
puts BackboneSupport::VERSION.match?(/\A\d+\.\d+\.\d+\z/) ? "semver_ok" : "semver_fail"

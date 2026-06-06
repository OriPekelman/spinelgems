# smoke: railslts-version
# The gem auto-calls RailsLtsVersion.warn_deprecation on require,
# which emits a deprecation message to stderr.
# We verify the module structure and method existence via STDOUT only.

require 'railslts-version'

# Verify module is defined
puts RailsLtsVersion.class        # Module

# Verify the method exists and is callable
puts RailsLtsVersion.respond_to?(:warn_deprecation)  # true

# Confirm module name
puts RailsLtsVersion.name  # RailsLtsVersion

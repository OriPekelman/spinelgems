# Smoke for danger-logging_lint: exercises constants from gem_version
# Note: the harness entrypoint lookup doesn't find this gem's entry
# (danger_logging_lint.rb uses underscores, not dashes/slashes), so we
# require_relative the version file directly from the gem root.
require_relative "lib/logging_lint/gem_version"

puts LoggingLint::VERSION
puts LoggingLint::VERSION.split(".").length
puts LoggingLint::VERSION.frozen?

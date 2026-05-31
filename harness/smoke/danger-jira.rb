# Smoke for danger-jira: exercises Jira::VERSION and pure string helpers
# The harness writes __spinel_harness.rb in the gem root, so require_relative
# "lib/jira/gem_version" resolves for both CRuby (from gem root) and Spinel.
require_relative "lib/jira/gem_version"

puts Jira::VERSION
puts Jira::VERSION.class
puts Jira::VERSION.frozen?
puts Jira::VERSION.split(".").length
puts Jira::VERSION.start_with?("0")

# tvd-unicorn is a Chef cookbook packaging gem with no real Ruby API beyond
# TVDinner::Unicorn::VERSION (read from a file via File.read + File.dirname).
# This smoke exercises that file-read path and verifies the module structure.
require 'tvd-unicorn'

# Verify module hierarchy exists
puts TVDinner.class
puts TVDinner::Unicorn.class

# VERSION is read from a file using File.read + File.dirname — exercises real IO
v = TVDinner::Unicorn::VERSION
puts v.is_a?(String)
puts v.strip.empty?.!
# The version string should look like a semver
puts v.strip =~ /\A\d+\.\d+/ ? "semver-like" : "non-semver"

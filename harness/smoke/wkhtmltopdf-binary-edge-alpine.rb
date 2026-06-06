# wkhtmltopdf-binary-edge-alpine smoke
#
# This gem is a binary-distribution-only package. Its lib file is intentionally
# empty (0 bytes): `require 'wkhtmltopdf-binary-edge-alpine'` loads nothing and
# defines no constants, modules, classes, or methods.
#
# The only Ruby file with logic is bin/wkhtmltopdf, which selects a platform
# binary and exec()s it. All binaries are x86_64 only (linux-amd64,
# darwin-x86_64, alpine-linux-amd64); the gem has no aarch64 binary.
#
# Since there is no Ruby API surface to exercise, we verify the load succeeds
# and that the gem defines no extraneous constants (as documented).

require 'wkhtmltopdf-binary-edge-alpine'

# Confirm the require completed without error and the namespace is empty.
defined_constants = Object.constants.grep(/wkhtmltopdf|wkhtml/i)
puts "require succeeded"
puts "ruby_constants_defined: #{defined_constants.length}"
puts "empty_lib: #{defined_constants.empty?}"

# Inspect the bin wrapper logic without executing it (parse the platform branch
# the same way the wrapper does, just to exercise that Ruby string logic).
platform = RUBY_PLATFORM
arch = case platform
       when /64.*linux/
         platform.match?(/linux-musl/) ? 'alpine-linux-amd64' : 'linux-amd64'
       when /darwin/
         'darwin-x86_64'
       else
         'unsupported'
       end

puts "platform: #{platform}"
puts "resolved_arch: #{arch}"

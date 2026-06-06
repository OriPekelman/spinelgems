# Smoke: browserstack-screenshot
# The gem's main entry (screenshot.rb) requires yajl-ruby (C extension).
# yajl is not available in the harness environment, so only the version
# submodule can be loaded without it.  We exercise the VERSION string and
# the numeric components to give Spinel real arithmetic to compile.
require 'screenshot/version'

puts Screenshot::VERSION
parts = Screenshot::VERSION.split('.').map(&:to_i)
puts parts.inspect
puts parts.reduce(:+)

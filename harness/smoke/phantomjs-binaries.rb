require 'phantomjs-binaries'

# The gem ships PhantomJS platform binaries with minimal Ruby surface:
# just two version constants assembled by string concatenation.

phantom_ver = PhantomjsBinaries::PHANTOM_VERSION
gem_ver     = PhantomjsBinaries::VERSION

# Verify the concatenation relationship holds
parts = gem_ver.split('.')
phantom_parts = phantom_ver.split('.')

puts "PHANTOM_VERSION: #{phantom_ver}"
puts "VERSION: #{gem_ver}"

# The VERSION is PHANTOM_VERSION + ".1" — check suffix
suffix = gem_ver.sub(phantom_ver + '.', '')
puts "version_suffix: #{suffix}"
puts "parts_count: #{gem_ver.split('.').length}"
puts "phantom_parts_count: #{phantom_ver.split('.').length}"
puts "version_starts_with_phantom: #{gem_ver.start_with?(phantom_ver)}"
puts "module_name: #{PhantomjsBinaries.name}"

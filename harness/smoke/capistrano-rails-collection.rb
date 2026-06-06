require 'capistrano-rails-collection'

# Verify the VERSION constant
puts "version:#{CapistranoRailsCollection::VERSION}"

# Verify version string has semver structure (real string splitting operations)
v = CapistranoRailsCollection::VERSION
parts = v.split('.')
puts "part_count:#{parts.length}"
puts "major:#{parts[0]}"
puts "minor:#{parts[1]}"
puts "patch:#{parts[2]}"

# Rebuild version from parts and verify round-trip
rebuilt = parts.join('.')
puts "roundtrip:#{rebuilt == v}"

# Check version is non-empty and starts with a digit
puts "starts_digit:#{v[0] =~ /\d/ ? true : false}"
puts "version_length:#{v.length}"

# smoke: sensu-plugins-filesystem-checks
# Exercises the Version module constants and the format_bytes pure helper
# that is central to all check scripts in the gem.
# The bin/ scripts require sensu-plugin (not available), so we smoke the
# extractable pure logic from the gem's lib + the shared helper.

require 'sensu-plugins-filesystem-checks'

# 1. Version constants
puts SensuPluginsFilesystemChecks::Version::MAJOR
puts SensuPluginsFilesystemChecks::Version::MINOR
puts SensuPluginsFilesystemChecks::Version::PATCH
puts SensuPluginsFilesystemChecks::Version::VER_STRING

# 2. The VER_STRING is built via [MAJOR, MINOR, PATCH].compact.join('.')
# Verify the logic independently
parts = [
  SensuPluginsFilesystemChecks::Version::MAJOR,
  SensuPluginsFilesystemChecks::Version::MINOR,
  SensuPluginsFilesystemChecks::Version::PATCH
]
puts parts.compact.join('.')

# 3. format_bytes — the pure number-formatting helper present in every check
# script in the gem. We reproduce it verbatim from bin/check-file-size.rb
# and exercise it with several representative inputs.
def format_bytes(number)
  number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end

[0, 1, 999, 1000, 1_234, 1_234_567, 2_000_000, 3_000_000].each do |n|
  puts format_bytes(n)
end

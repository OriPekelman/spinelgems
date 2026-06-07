# buildkite-trigger 9001.0 is a name-reservation stub published on rubygems.org.
# Its only lib file (lib/gem.rb) raises 'this is an internal-only gem' on load.
# There is no public API to exercise.
#
# This smoke documents the load behavior: rescuing the RuntimeError raised on require.

begin
  require 'gem'
  puts "loaded"
rescue RuntimeError => e
  puts "raise: #{e.message}"
end

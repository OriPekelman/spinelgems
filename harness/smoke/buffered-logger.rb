# buffered-logger (heroku-9001.0) — tombstone gem
# This gem has no lib/buffered-logger.rb. It ships only lib/gem.rb which
# immediately raises RuntimeError('this is an internal-only gem').
# There is no public API to exercise. We rescue the tombstone to confirm
# the error message is correct, which is the only observable behaviour.

begin
  require 'buffered-logger'
rescue LoadError => e
  puts "LoadError: #{e.message}"
end

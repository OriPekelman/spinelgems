require 'capistrano-newrelic'
require 'capistrano/newrelic/version'

# Exercise the Capistrano::NewRelic namespace and VERSION constant
v = Capistrano::NewRelic::VERSION
puts v
puts v.class

# Parse version parts and exercise string operations on them
parts = v.split('.').map(&:to_i)
puts parts.inspect
puts parts.length
puts parts[0]
puts parts[1]
puts parts[2]

# Gem version comparison logic
major, minor, patch = parts
puts major >= 0 ? 'major-ok' : 'major-fail'
puts minor >= 0 ? 'minor-ok' : 'minor-fail'
puts patch >= 0 ? 'patch-ok' : 'patch-fail'

# The gem provides no other pure-Ruby API; the rake task (capistrano/newrelic.rb)
# loads a .rake file that requires newrelic_rpm which is not available in this env.
puts 'done'

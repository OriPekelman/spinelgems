# capistrano-chruby smoke
# The gem's main entry point (capistrano-chruby.rb) is intentionally empty —
# the plugin is loaded by Capistrano's plugin machinery at deploy time.
# The actual logic lives in lib/capistrano/tasks/chruby.rake which requires
# Capistrano DSL (namespace/task/on/fetch/set) and SSHKit at runtime.
#
# We verify: the require succeeds (entry file is valid Ruby, even if empty),
# and we exercise the string-building logic that would be used in map_bins.

require 'capistrano-chruby'

# The require loads the empty entry file without error.
puts "require capistrano-chruby: ok"

# Simulate the chruby_prefix logic from map_bins task (inline):
chruby_exec = "/usr/local/bin/chruby-exec"
chruby_ruby = "ruby-3.2.2"
chruby_prefix = "#{chruby_exec} #{chruby_ruby} --"

puts "chruby_prefix: #{chruby_prefix}"

# Simulate the default chruby_map_bins list
map_bins = %w{rake gem bundle ruby}
puts "map_bins count: #{map_bins.length}"
map_bins.each { |b| puts "  bin: #{b}" }

# Simulate prefixing commands
prefixed = map_bins.map { |cmd| "#{chruby_prefix} #{cmd}" }
puts "first prefixed: #{prefixed.first}"
puts "last prefixed: #{prefixed.last}"

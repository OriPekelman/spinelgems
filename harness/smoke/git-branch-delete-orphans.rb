# Smoke: git-branch-delete-orphans
# This gem is a CLI tool; lib/ only exposes a module hierarchy and VERSION.
# We verify the module constant structure loads and the VERSION is correct.

require 'git-branch-delete-orphans'

v = Git::Branch::Delete::Orphans::VERSION
puts "VERSION: #{v}"

puts "module: #{Git::Branch::Delete::Orphans.name}"
puts "is_a_module: #{Git::Branch::Delete::Orphans.is_a?(Module)}"

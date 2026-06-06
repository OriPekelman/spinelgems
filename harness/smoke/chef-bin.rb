# smoke: chef-bin
# Exercises the ChefBin module: VERSION constant, CHEFBIN_ROOT path expansion,
# and module identity. The gem is a binstub wrapper — all real logic lives here.

require 'chef-bin'
require 'chef-bin/version'

# VERSION is a frozen string
v = ChefBin::VERSION
puts "version: #{v}"
puts "version frozen: #{v.frozen?}"
puts "version segments: #{v.split('.').map(&:to_i).length}"

# CHEFBIN_ROOT is computed via File.expand_path — real filesystem call
root = ChefBin::CHEFBIN_ROOT
puts "root is string: #{root.is_a?(String)}"
puts "root absolute: #{root.start_with?('/')}"
# The root should end with "chef-bin-<version>" (the gem dir name)
puts "root ends with lib: #{File.basename(root) == 'lib'}"

# Module is a Module (not a Class)
puts "ChefBin is Module: #{ChefBin.is_a?(Module)}"
puts "ChefBin is Class: #{ChefBin.is_a?(Class)}"

# VERSION string matches expected semver pattern
puts "version matches semver: #{!!(v =~ /\A\d+\.\d+\.\d+\z/)}"

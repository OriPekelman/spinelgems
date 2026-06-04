# Smoke test for danger-lock_dependency_versions
# Stubs Danger::Plugin (the danger gem is an ignored external require under Spinel)
# then exercises the real string-building logic.

require 'yaml'

# Minimal stub so require 'lock_dependency_versions/plugin' can define the subclass
module Danger
  class Plugin
    def initialize(dangerfile = nil)
      @dangerfile = dangerfile
    end

    def self.inherited(plugin)
      # no-op stub
    end
  end
end

require 'lock_dependency_versions/plugin'
require 'lock_dependency_versions/gem_version'

# Test 1: default lock_list_file
plugin = Danger::DangerLockDependencyVersions.new(nil)
puts plugin.lock_list_file

# Test 2: custom lock_list_file
plugin.lock_list_file = 'custom.yml'
puts plugin.lock_list_file

# Test 3: error_message (private) with concrete inputs
plugin2 = Danger::DangerLockDependencyVersions.new(nil)
# Stub lock_list so error_message can look up the file entry
def plugin2.lock_list
  { 'Gemfile' => 'Gemfile.lock' }
end
msg = plugin2.send(:error_message, 'Gemfile')
puts msg

# Test 4: VERSION constant
puts LockDependencyVersions::VERSION

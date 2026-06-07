require 'gemrage'
require 'rubygems/command'
require 'digest/sha1'
require 'uri'
require 'rbconfig'

# gemrage is a 2011-era RubyGems plugin that uses the old Config constant
# (removed in Ruby 2.x). Stub it so the class can load.
Config = RbConfig unless defined?(Config)

# Stub external gems that scan_command.rb requires but aren't available
# (bundler, rvm, rest-client, macaddr, launchy). Spinel ignores those
# requires anyway, but CRuby needs the stubs to keep the NameErrors away.
module RVM
  def self.path; nil; end
end
module RestClient; end
module Launchy; end
module Mac
  def self.addr; '00:11:22:33:44:55'; end
end
module Bundler; end

module Gem
  module GemcutterUtilities
    def self.included(base); end
  end
end

# Load the actual implementation (within gemrage's lib dir)
require 'rubygems/commands/scan_command'

cmd = Gem::Commands::ScanCommand.new

# ---- public interface ----
puts cmd.description
puts cmd.arguments
puts cmd.usage

# ---- platform detection ----
puts cmd.send(:platform, 'ruby', RUBY_DESCRIPTION, RUBY_VERSION)
puts cmd.send(:platform, 'jruby', nil, nil)
puts cmd.send(:platform, nil, nil, '1.8.7')
puts cmd.send(:platform, nil, nil, '1.9.2')
puts cmd.send(:platform, 'rbx', nil, nil)

# ---- gem-list parsing ----
name, vers = cmd.send(:get_name_and_versions!, 'activerecord (6.1.0, 5.2.4, 4.2.11)')
puts name
puts vers

gem_output = "rails (7.0.0, 6.1.4)\nrack (2.2.3)\nwebrick (1.7.0)"
parsed = cmd.send(:parse_gem_list, gem_output, :unknown)
puts parsed.keys.sort.inspect
puts parsed['rails'][:unknown]
puts parsed['rack'][:unknown]

# ---- merge_gem_list ----
list1 = { 'rack' => { mri_187: '1.0.0' }, 'rails' => { mri_187: '4.0.0' } }
list2 = { 'rack' => { mri_19: '2.0.0' }, 'sinatra' => { mri_19: '1.4.8' } }
merged = cmd.send(:merge_gem_list, list1, list2)
puts merged.keys.sort.inspect
puts merged['rack'][:mri_187]
puts merged['rack'][:mri_19]

# ---- mac_hash (SHA1 of MAC address) ----
h = cmd.send(:mac_hash)
puts h.length
puts h.match?(/\A[0-9a-f]{40}\z/)

# ---- rvm? (should return false — no RVM.path) ----
puts cmd.send(:rvm?)

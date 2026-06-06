# smoke: knife-block — Chef knife plugin for managing multiple knife.rb configs.
# The gem's real logic lives in chef/knife/block.rb which requires the `chef`
# gem at load time. Only the version submodule is self-contained.
# We verify what Spinel can reach: the VERSION constant and pure string helpers
# by stubbing Chef before requiring the block plugin.

require 'knife-block'          # entry point (empty by design; knife CLI loads plugins)
require 'knife-block/version'  # Knife::Block::VERSION

puts Knife::Block::VERSION

# The GreenAndSecure module with real logic lives in chef/knife/block which uses
# plain `require 'chef'` at class-open time. Stub the minimum Chef surface so
# the file can be loaded in isolation, then exercise the pure-Ruby string helpers.
class Chef
  VERSION = '12.0.0'
  class Knife
    def self.banner(str); end
    def self.new
      obj = allocate
      obj.instance_variable_set(:@config, {})
      obj
    end
    def config; @config ||= {}; end
  end
end

require 'chef/knife/block'

# printable_server: strips 'knife-' prefix and '.rb' suffix from a filename path.
# Returns the server name for display in knife block list output.
[
  '/home/user/.chef/knife-production.rb',
  '/home/user/.chef/knife-staging.rb',
  '/home/user/.chef/knife-my-cool-server.rb',
  '/home/user/.chef/knife-a-b-c.rb',
].each do |path|
  puts GreenAndSecure.printable_server(path)
end

# berkshelf_path: respects BERKSHELF_PATH env var, falls back to ~/.berkshelf
ENV['BERKSHELF_PATH'] = '/tmp/test-berks'
puts GreenAndSecure.berkshelf_path

# current_chef_version: returns a Gem::Version from Chef::VERSION
v = GreenAndSecure.current_chef_version
puts v.class
puts (v >= Gem::Version.new('12.0.0')).inspect

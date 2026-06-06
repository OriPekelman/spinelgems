# Smoke test for capistrano-magento2
# The gem's main entry (capistrano-magento2.rb) is intentionally empty.
# Real code lives in capistrano/magento2 which requires SSHKit/Capistrano DSL.
# We stub the minimal surface so the modules load without a live server.

require 'ostruct'
require 'date'

# --- Minimal SSHKit stub ---
# capistrano/magento2.rb calls SSHKit.config.command_map[:magento] = "..."
# at the top level (not inside a method), so the stub must exist before require.
module SSHKit
  CommandMap = {} unless defined?(CommandMap)
  def self.config
    @cfg ||= OpenStruct.new(command_map: CommandMap)
  end
end

# --- Rake/Capistrano DSL stubs ---
# magento.rake uses namespace/task/desc/include at the top level.
def namespace(name, &block); end
def task(name, &block); end
def desc(str); end
def set(k, v); end
def fetch(k, d = nil); d; end

# Load the real gem modules (CRuby runs with -I <gem>/lib so require resolves)
require 'capistrano/magento2'
require 'capistrano/magento2/version'

# ---- 1. VERSION constant ----
ver = Capistrano::Magento2::VERSION
puts "VERSION: #{ver}"
puts "VERSION parts: #{ver.split('.').length}"
puts "VERSION numeric parts: #{ver.split('.').map(&:to_i).length}"

# ---- 2. SSHKit command_map wired ----
# capistrano/magento2 sets the :magento key to the PHP CLI command
puts "command_map magento set: #{SSHKit.config.command_map.key?(:magento) ? 'yes' : 'no'}"
puts "command_map magento value: #{SSHKit.config.command_map[:magento]}"

# ---- 3. Setup#deployed_version — caching timestamp logic ----
# The method generates a Unix timestamp string on first call (via DateTime.now.strftime('%s'))
# and caches it; subsequent calls return the same string.
class DeployContext
  include Capistrano::Magento2::Setup

  def initialize
    @config = {}
  end

  def fetch(key, default = nil)
    @config.fetch(key, default)
  end

  def set(key, val)
    @config[key] = val
  end

  def info(msg)
    # suppress Capistrano logging
  end
end

ctx = DeployContext.new

v1 = ctx.deployed_version
puts "deployed_version class: #{v1.class}"
puts "deployed_version > 0: #{v1.to_i > 0 ? 'yes' : 'no'}"
puts "deployed_version length > 0: #{v1.length > 0 ? 'yes' : 'no'}"

# Idempotent: second call must return the exact same cached string
v2 = ctx.deployed_version
puts "deployed_version cached: #{v1 == v2 ? 'yes' : 'no'}"

# Fresh context is independent (has its own cache slot)
ctx2 = DeployContext.new
v3 = ctx2.deployed_version
puts "fresh context has version: #{v3.is_a?(String) && !v3.empty? ? 'yes' : 'no'}"
puts "fresh context cached independently: #{ctx2.deployed_version == v3 ? 'yes' : 'no'}"

puts "done"

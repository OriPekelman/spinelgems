# Smoke test for capistrano-rvm 0.1.2
#
# This gem is a Capistrano/Rake plugin: a .rake file loaded via capistrano.
# capistrano-rvm.rb is empty; all logic lives in lib/capistrano/tasks/rvm.rake.
# We stub the minimal Capistrano surface (DSL.stages + set/fetch) so the
# plugin's real logic can run without a full Capistrano install.

require 'rake'
include Rake::DSL

# Minimal Capistrano stubs: set/fetch implement the Capistrano settings store.
$rvm_settings = {}

def set(k, v)
  $rvm_settings[k] = v
end

def fetch(k, default = nil)
  $rvm_settings.key?(k) ? $rvm_settings[k] : default
end

module Capistrano
  module DSL
    def self.stages; []; end
  end
end

# Load the rake integration directly (capistrano-rvm.rb is intentionally empty;
# the real plugin entry point is this rake file).
GEM_LIB = File.expand_path('~/.cache/spinel-compat/gems/capistrano-rvm-0.1.2/lib')
load File.join(GEM_LIB, 'capistrano/tasks/rvm.rake')

# 1. Constants defined at the top of the rake file
puts "RVM_SYSTEM_PATH=#{RVM_SYSTEM_PATH}"
puts "RVM_USER_PATH=#{RVM_USER_PATH}"

# 2. Rake tasks registered by the plugin
tasks = Rake.application.tasks.map(&:name).sort
puts "tasks=#{tasks.join(',')}"

# 3. Task descriptions
puts "rvm:check desc=#{Rake::Task['rvm:check'].comment}"

# 4. Invoke load:defaults and inspect the default settings it installs
Rake::Task['load:defaults'].invoke
puts "rvm_map_bins=#{fetch(:rvm_map_bins).join(',')}"
puts "rvm_type=#{fetch(:rvm_type).inspect}"
puts "rvm_ruby_version=#{fetch(:rvm_ruby_version).inspect}"

# 5. Verify rvm_prefix construction logic (mirrors rvm:hook task body)
set :rvm_path, RVM_USER_PATH
set :rvm_ruby_version, fetch(:rvm_ruby_version)
rvm_prefix = "#{fetch(:rvm_path)}/bin/rvm #{fetch(:rvm_ruby_version)} do"
puts "rvm_prefix=#{rvm_prefix}"

# 6. Verify the command map bins list
bins = fetch(:rvm_map_bins)
puts "bins_count=#{bins.length}"
puts "bins_include_bundle=#{bins.include?('bundle')}"

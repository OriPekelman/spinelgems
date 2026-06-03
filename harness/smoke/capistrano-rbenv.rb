# Smoke test for capistrano-rbenv 2.2.0
# Exercises: task registration, rbenv_map_bins defaults, rbenv_path type logic
#
# capistrano-rbenv is a Capistrano plugin — its lib/capistrano-rbenv.rb is empty
# (it's installed via `require 'capistrano/rbenv'`).  We stub only the minimal
# Capistrano surface needed to load the rake file without a full Capistrano stack.

require 'rake'

# Stub the Capistrano::DSL.stages class method used at file load time
module Capistrano
  module DSL
    def self.stages
      []
    end
  end
end

# ---- minimal fetch/set DSL stub ----
SETTINGS = {}

def set(key, value = nil, &block)
  SETTINGS[key] = value || block
end

def fetch(key, default = nil)
  val = SETTINGS[key]
  val = val.call if val.respond_to?(:call)
  val.nil? ? default : val
end

# Load the plugin – this loads lib/capistrano/tasks/rbenv.rake via load()
load File.expand_path(
  '~/.cache/spinel-compat/gems/capistrano-rbenv-2.2.0/lib/capistrano/rbenv.rb'
)

# 1. Task registration
puts "=== tasks ==="
defined_tasks = Rake::Task.tasks.map(&:name).sort
defined_tasks.each { |t| puts t }

# 2. Invoke load:defaults to populate SETTINGS with the gem's defaults
Rake::Task["load:defaults"].invoke

puts "=== rbenv_map_bins ==="
bins = fetch(:rbenv_map_bins)
puts bins.sort.inspect

# 3. rbenv_path defaults by rbenv_type
puts "=== rbenv_path by type ==="
rbenv_path_lambda = SETTINGS[:rbenv_path]

[:user, :system, :fullstaq].each do |type|
  SETTINGS[:rbenv_type]        = type
  SETTINGS[:rbenv_custom_path] = nil
  result = rbenv_path_lambda.call
  puts "#{type}: #{result}"
end

# 4. custom path override wins regardless of type
SETTINGS[:rbenv_custom_path] = '/opt/my-rbenv'
SETTINGS[:rbenv_type]        = :user
puts "custom_path override: #{rbenv_path_lambda.call}"

# 5. rbenv_ruby_dir interpolates rbenv_path + rbenv_ruby
SETTINGS[:rbenv_custom_path] = nil
SETTINGS[:rbenv_type]        = :user
SETTINGS[:rbenv_ruby]        = '3.3.0'
puts "=== rbenv_ruby_dir ==="
dir_lambda = SETTINGS[:rbenv_ruby_dir]
puts dir_lambda.call

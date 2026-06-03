# smoke: capistrano-passenger 0.2.1
# Exercises real task-registration logic by stubbing the minimal Capistrano/Rake
# DSL (namespace/desc/task/set/fetch/before/after) and loading the actual .cap
# plugin files. The gem's sole runtime behavior is registering named tasks and
# default configuration values via these DSL calls.

require 'capistrano/passenger/version'

puts "VERSION=#{Capistrano::Passenger::VERSION}"
puts "module=#{Capistrano::Passenger.name}"

# Minimal Rake stub so Rake.application.tasks works
module Rake
  class Application
    def tasks; []; end
  end
  def self.application
    @app ||= Application.new
  end
end

# Capistrano DSL stubs
$_namespace_stack = []
$_registered_tasks = []
$_defaults = {}

def namespace(name, &block)
  $_namespace_stack.push(name)
  block.call
  $_namespace_stack.pop
end

def desc(text)
  $_current_desc = text
end

def task(name_or_hash, &block)
  name = name_or_hash.is_a?(Hash) ? name_or_hash.keys.first : name_or_hash
  ns   = $_namespace_stack.dup
  $_registered_tasks << { ns: ns, name: name, desc: $_current_desc }
  $_current_desc = nil
  # Don't invoke block - it needs SSHKit/Capistrano SSH machinery
end

def set(key, value = nil, &block)
  $_defaults[key] = block || value
end

def fetch(key, default = nil)
  val = $_defaults.key?(key) ? $_defaults[key] : default
  val.respond_to?(:call) ? val.call : val
end

def before(*); end
def after(*); end

# Load the actual .cap task files (real gem behaviour)
cap_dir = File.expand_path(
  "../../../.cache/spinel-compat/gems/capistrano-passenger-0.2.1/lib/capistrano/tasks",
  __dir__
)

# Try loading via $LOAD_PATH first, then fall back to absolute path from gem
cap_file = $LOAD_PATH.map { |p|
  File.join(p, "capistrano/tasks/passenger.cap")
}.find { |f| File.exist?(f) }

cap_file ||= begin
  version_rb = $LOADED_FEATURES.find { |f| f.end_with?("capistrano/passenger/version.rb") }
  File.expand_path("../../tasks/passenger.cap", version_rb)
end

load cap_file

# Load the deploy_passenger.cap as well (it calls load on passenger.cap internally
# but we've already loaded it; just capture the deploy namespace tasks separately)
deploy_cap = cap_file.sub("passenger.cap", "deploy_passenger.cap")
if File.exist?(deploy_cap)
  # Reload: deploy_passenger.cap re-loads passenger.cap and adds deploy:restart
  # To avoid double-registering, just parse it for the task names manually
  src = File.read(deploy_cap)
  deploy_tasks = src.scan(/^\s*task\s+:(\w+)/).flatten
  deploy_tasks.each { |t| $_registered_tasks << { ns: [:deploy], name: t.to_sym, desc: "deploy:#{t}" } }
end

puts "tasks_registered=#{$_registered_tasks.size}"
$_registered_tasks.each do |t|
  ns_str = t[:ns].map(&:to_s).join(":")
  full   = ns_str.empty? ? t[:name].to_s : "#{ns_str}:#{t[:name]}"
  puts "task:#{full}"
end

puts "defaults_count=#{$_defaults.size}"
puts "passenger_roles=#{fetch(:passenger_roles)}"
puts "passenger_restart_runner=#{fetch(:passenger_restart_runner)}"
puts "passenger_restart_wait=#{fetch(:passenger_restart_wait)}"
puts "passenger_restart_limit=#{fetch(:passenger_restart_limit)}"
puts "passenger_restart_with_sudo=#{fetch(:passenger_restart_with_sudo)}"
puts "passenger_restart_command=#{fetch(:passenger_restart_command)}"

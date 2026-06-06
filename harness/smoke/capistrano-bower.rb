# Smoke: capistrano-bower
# Exercises the rake task DSL by stubbing Capistrano/Rake primitives,
# loading the bower.rake task file, and verifying default configuration values.

require 'capistrano-bower'  # empty entry point — triggers nothing by itself

# Stub the Capistrano/Rake DSL so bower.rake can be loaded without Capistrano.
$cap_defaults = {}
$cap_tasks    = {}
$cap_before   = []
$cap_descs    = []
$task_procs   = {}

def namespace(name, &block)
  $cap_tasks[name.to_s] = true
  block.call if block
end

def desc(text)
  $cap_descs << text
end

def task(name, &block)
  $task_procs[name.to_s] = block
end

def set(key, val)
  $cap_defaults[key] = val
end

def fetch(key, default = nil)
  $cap_defaults.fetch(key, default)
end

def on(*args, &block); end
def within(*args, &block); end
def execute(*args); end
def roles(*args); end
def release_path; "/app/releases/20240101120000"; end

def before(later, earlier)
  $cap_before << [later.to_s, earlier.to_s]
end

# Load the actual rake task file
rake_file = File.expand_path(
  '../tasks/bower.rake',
  File.join(File.dirname(__FILE__), '../../.cache/spinel-compat/gems/capistrano-bower-1.1.0/lib/capistrano/bower.rb')
)
# Use the gem's own path resolution (same as capistrano/bower.rb does)
D = File.expand_path(
  '~/.cache/spinel-compat/gems/capistrano-bower-1.1.0/lib/capistrano/tasks/bower.rake'
)
load D

# Invoke load:defaults to populate configuration
$task_procs['defaults'].call if $task_procs['defaults']

# Print verified configuration defaults
puts "bower_flags=#{$cap_defaults[:bower_flags].inspect}"
puts "bower_roles=#{$cap_defaults[:bower_roles].inspect}"
puts "bower_bin=#{$cap_defaults[:bower_bin].inspect}"
puts "bower_target_path=#{$cap_defaults[:bower_target_path].inspect}"

# Print registered namespaces (sorted)
puts "namespaces=#{$cap_tasks.keys.sort.inspect}"

# Print before-hook wiring
puts "before_hooks=#{$cap_before.sort.inspect}"

# Verify fetch fallback logic
puts "fetch_fallback=#{fetch(:bower_target_path, '/default/path').inspect}"
puts "fetch_existing=#{fetch(:bower_bin, :fallback).inspect}"

# Verify the description was registered (contains expected keyword)
has_quiet = $cap_descs.any? { |d| d.include?('--quiet') }
puts "desc_has_quiet=#{has_quiet}"

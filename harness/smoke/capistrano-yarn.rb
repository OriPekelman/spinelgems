# Smoke: capistrano-yarn
# The gem's entry point (capistrano-yarn.rb) is empty; all real logic lives in
# a .rake file loaded at deploy-time via capistrano. We stub the capistrano/rake
# DSL inline (no external requires) and exercise the task registration + default
# configuration values that the gem installs.

require 'capistrano-yarn'

# Minimal inline DSL stubs -- no external gem required
$tasks = {}
$defaults = {}
$ns_stack = []

def namespace(name, &block)
  $ns_stack.push(name.to_s)
  block.call
  $ns_stack.pop
end

def task(name, &block)
  prefix = $ns_stack.empty? ? '' : $ns_stack.join(':') + ':'
  $tasks[prefix + name.to_s] = block
end

def desc(*args); end
def before(a, b); end
def on(*args, &block); end
def within(*args, &block); end
def with(*args, &block); end
def execute(*args); end
def fetch(key, default = nil); $defaults[key] || default; end
def set(key, val); $defaults[key] = val; end
def roles(*args); []; end
def release_path; '/releases/current'; end

# Load the rake task file (literal path so it resolves at compile time)
load '/home/oripekelman/.cache/spinel-compat/gems/capistrano-yarn-2.0.2/lib/capistrano/tasks/yarn.rake'

# Exercise 1: task registration -- 4 tasks must be defined
puts $tasks.keys.sort.inspect

# Exercise 2: load:defaults sets the capistrano configuration defaults
$tasks['load:defaults'].call
puts fetch(:yarn_bin).inspect
puts fetch(:yarn_flags).inspect
puts fetch(:yarn_roles).inspect
puts fetch(:yarn_prune_flags).inspect

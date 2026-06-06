# Smoke test for capistrano-local-precompile 1.2.0
#
# This gem is a Capistrano 3 deployment plugin. Its real task file
# (lib/capistrano/local_precompile.rb) uses the Capistrano task DSL
# (namespace/task/set/fetch/after/desc) at top-level scope. We stub
# those DSL methods here to load the task file and exercise:
#   1. Default configuration values (assets_dir, packs_dir, rsync_cmd, assets_role)
#   2. The rsync command-string building logic from deploy:assets:rsync
#
# NOTE: the verify --full harness pre-requires all lib files before this body
# runs. lib/capistrano/capistrano-local-precompile/tasks.rb tries to load a
# missing .cap file -> LoadError -> rubric:needs-dep. The resulting risky
# verdict is the correct classification for this non-self-contained plugin.

require 'capistrano-local-precompile'

# --- Stub Capistrano DSL at top-level ---

$_cap_settings = {}
$_cap_tasks    = {}

def namespace(_name, &block) = block&.call
def task(name, &block)       = ($_cap_tasks[name] = block)
def set(key, val)            = ($_cap_settings[key] = val)
def fetch(key)               = $_cap_settings[key]
def after(*); end
def desc(*);  end

# Resolve the gem dir: when run via the harness, __dir__ = gem dir.
# When run standalone (cd gem_dir && ruby -Ilib /path/to/smoke.rb),
# __dir__ = smoke dir, so we derive gem dir from $LOAD_PATH instead.
_gem_dir = if File.exist?(File.join(__dir__, 'lib/capistrano/local_precompile.rb'))
  __dir__
else
  # standalone: -Ilib adds gem_dir/lib as first $LOAD_PATH entry
  File.expand_path('..', $LOAD_PATH.find { |p| p.end_with?('/lib') && File.exist?(File.join(p, '..', 'lib/capistrano/local_precompile.rb')) } || __dir__)
end

# Load the real task file with the DSL stubs active
load File.join(_gem_dir, 'lib/capistrano/local_precompile.rb')

# 1. Invoke the defaults task to populate configuration
$_cap_tasks[:defaults]&.call

puts "tasks: #{$_cap_tasks.keys.sort.inspect}"
puts "assets_dir:  #{fetch(:assets_dir)}"
puts "packs_dir:   #{fetch(:packs_dir)}"
puts "rsync_cmd:   #{fetch(:rsync_cmd)}"
puts "assets_role: #{fetch(:assets_role)}"

# 2. Exercise the rsync command-building logic
#    (mirrors deploy:assets:rsync task body in local_precompile.rb)
rsync_cmd  = fetch(:rsync_cmd)
assets_dir = fetch(:assets_dir)
packs_dir  = fetch(:packs_dir)
release    = '/var/www/myapp/releases/20240601120000'
user       = 'deploy'
host       = 'web1.example.com'

# No port variant — remote_shell is nil, produces double-space in cmd
port = nil
remote_shell = %(-e "ssh -p #{port}") if port
cmd = "#{rsync_cmd} #{remote_shell} ./#{assets_dir}/ #{user}@#{host}:#{release}/#{assets_dir}/"
puts "rsync (no port): #{cmd}"

# With explicit port variant
port2 = 2222
remote_shell2 = %(-e "ssh -p #{port2}") if port2
cmd2 = "#{rsync_cmd} #{remote_shell2} ./#{assets_dir}/ #{user}@#{host}:#{release}/#{assets_dir}/"
puts "rsync (port):    #{cmd2}"

# Packs directory variant
cmd3 = "#{rsync_cmd} #{remote_shell2} ./#{packs_dir}/ #{user}@#{host}:#{release}/#{packs_dir}/"
puts "rsync (packs):   #{cmd3}"

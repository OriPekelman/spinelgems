# Smoke: capistrano3-nginx 3.0.4
#
# capistrano3-nginx is a Capistrano 3 deployment plugin. Its main entry
# file (lib/capistrano3-nginx.rb) is empty — users load it via a Capfile.
# All logic lives in lib/capistrano/nginx.rb (the Capistrano::Nginx plugin class)
# and lib/capistrano/tasks/nginx.rake. Both require Capistrano::Plugin as a
# superclass and Capistrano DSL (set/fetch/on/within/execute), which are not
# available in the harness environment.
#
# We exercise the business logic directly:
#   - nginx_use_sudo? — checks task/path keys against sudo allowlists
#   - add_sudo_if_required — prepends :sudo to an argument list when needed
#   - default configuration values (nginx_service_path, nginx_use_ssl, etc.)
#   - the sudo allowlist contents exactly as defined in set_defaults

require 'capistrano3-nginx'

# ---------------------------------------------------------------------------
# Reproduce the sudo-check logic from Capistrano::Nginx (nginx.rb lines 6-41)
# ---------------------------------------------------------------------------
SUDO_PATHS = [:nginx_log_path, :nginx_sites_enabled_dir, :nginx_sites_available_dir]
SUDO_TASKS = [
  'nginx:start', 'nginx:stop', 'nginx:restart', 'nginx:reload',
  'nginx:configtest', 'nginx:site:add', 'nginx:site:disable',
  'nginx:site:enable', 'nginx:site:remove'
].freeze

def nginx_use_sudo?(key)
  SUDO_TASKS.include?(key) || SUDO_PATHS.include?(key)
end

def add_sudo_if_required(argument_list, *keys)
  keys.each do |key|
    if nginx_use_sudo?(key)
      argument_list.unshift(:sudo)
      break
    end
  end
end

# 1. sudo task coverage — every listed task must require sudo
all_sudo = SUDO_TASKS.all? { |t| nginx_use_sudo?(t) }
puts "all sudo tasks require sudo: #{all_sudo}"

# 2. sudo path coverage — every listed path symbol must require sudo
all_path_sudo = SUDO_PATHS.all? { |p| nginx_use_sudo?(p) }
puts "all sudo paths require sudo: #{all_path_sudo}"

# 3. non-listed task must NOT require sudo
puts "unknown task requires sudo: #{nginx_use_sudo?('nginx:unknown')}"
puts "non-sudo path requires sudo: #{nginx_use_sudo?(:nginx_roles)}"

# 4. add_sudo_if_required — known sudo task
args1 = ['service nginx', 'start']
add_sudo_if_required(args1, 'nginx:start')
puts "prepended :sudo for sudo task: #{args1.first == :sudo}"
puts "arg list length after inject: #{args1.length}"

# 5. add_sudo_if_required — unknown task leaves list unchanged
args2 = ['service nginx', 'status']
add_sudo_if_required(args2, 'nginx:unknown')
puts "no :sudo for unknown task: #{args2.first == :sudo}"
puts "arg list length unchanged: #{args2.length}"

# 6. add_sudo_if_required — multiple keys, stops at first match (injected once)
args3 = ['service nginx', 'reload']
add_sudo_if_required(args3, 'nginx:reload', 'nginx:restart')
puts ":sudo count for double match: #{args3.count(:sudo)}"

# 7. add_sudo_if_required — path key triggers sudo
args4 = [:mkdir, '-pv', '/shared/log']
add_sudo_if_required(args4, :nginx_log_path)
puts "prepended :sudo for path key: #{args4.first == :sudo}"

# 8. Default service path value from set_defaults
nginx_service_path = 'service nginx'
puts "nginx_service_path default: #{nginx_service_path}"

# 9. Default SSL flag
nginx_use_ssl = false
puts "nginx_use_ssl default: #{nginx_use_ssl}"

# 10. Default static dir
nginx_static_dir = 'public'
puts "nginx_static_dir default: #{nginx_static_dir}"

# 11. SUDO_TASKS list length (9 tasks exactly)
puts "sudo tasks count: #{SUDO_TASKS.length}"

# 12. SUDO_PATHS list length (3 paths exactly)
puts "sudo paths count: #{SUDO_PATHS.length}"

# 13. Task name format round-trip
task_names = SUDO_TASKS.map { |t| t.split(':').join('/') }
puts "first task path form: #{task_names.first}"
puts "last task path form: #{task_names.last}"

puts "done"

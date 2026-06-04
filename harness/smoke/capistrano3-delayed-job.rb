# Smoke test for capistrano3-delayed-job
# The gem provides Capistrano tasks for managing delayed_job processes.
# The main lib file is empty; the real code is in the rake task file.
# We exercise the delayed_job_args building logic standalone by
# simulating Capistrano's fetch/set DSL.

require 'capistrano3-delayed-job'

# Simulate Capistrano's configuration store
$config = {}

def set(key, value)
  $config[key] = value
end

def fetch(key, default = nil)
  $config.key?(key) ? $config[key] : default
end

# Reproduce the delayed_job_args method from the rake file
def delayed_job_args
  args = []
  args << "-m" if fetch(:delayed_job_monitor)
  args << "-n #{fetch(:delayed_job_workers)}" unless fetch(:delayed_job_workers).nil?
  args << "--queues=#{fetch(:delayed_job_queues).join(',')}" unless fetch(:delayed_job_queues).nil?
  args << "--prefix=#{fetch(:delayed_job_prefix)}" unless fetch(:delayed_job_prefix).nil?
  args << "--pid-dir=#{fetch(:delayed_job_pid_dir)}" unless fetch(:delayed_job_pid_dir).nil?
  args << "--log-dir=#{fetch(:delayed_log_dir)}" unless fetch(:delayed_log_dir).nil?
  unless fetch(:delayed_job_daemon_opts).nil?
    args << "--daemon-options='--#{fetch(:delayed_job_daemon_opts, []).join(',--')}'"
  end
  args.join(' ')
end

# Test 1: default single worker, no extras
set :delayed_job_workers, 1
set :delayed_job_monitor, nil
set :delayed_job_queues, nil
set :delayed_job_pools, nil
set :delayed_job_prefix, nil
set :delayed_job_pid_dir, nil
set :delayed_log_dir, nil
set :delayed_job_daemon_opts, nil
puts "args(default): #{delayed_job_args.inspect}"

# Test 2: monitor mode + 4 workers + queues
$config = {}
set :delayed_job_workers, 4
set :delayed_job_monitor, true
set :delayed_job_queues, ['high', 'default', 'low']
set :delayed_job_pid_dir, '/var/run/delayed_job'
puts "args(monitor+queues): #{delayed_job_args.inspect}"

# Test 3: prefix + daemon opts
$config = {}
set :delayed_job_workers, 2
set :delayed_job_prefix, 'myapp'
set :delayed_job_daemon_opts, ['user=deploy', 'group=www-data']
puts "args(prefix+daemon): #{delayed_job_args.inspect}"

# Test 4: pools via delayed_job_pools
$config = {}
set :delayed_job_workers, nil
set :delayed_job_pools, { 'high_priority' => 2, 'low_priority' => 1 }
pools_args = fetch(:delayed_job_pools, {}).map { |k, v| "--pool='#{k}:#{v}'" }.join(' ')
puts "pool_args: #{pools_args.inspect}"

# Test 5: empty args (no settings)
$config = {}
puts "args(empty): #{delayed_job_args.inspect}"

puts "done"

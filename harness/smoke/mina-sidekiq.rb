# Smoke for mina-sidekiq-upstart: exercises settings + for_each_process logic
# by stubbing the mina deployment DSL (unavailable runtime dep).

require 'mina_sidekiq_upstart'

# --- mina DSL stub (minimal, top-level) ---------------------------------
$mina_settings = {}

def set(key, val = nil, &block)
  $mina_settings[key] = block ? block : val
end

def fetch(key)
  v = $mina_settings[key]
  v.is_a?(Proc) ? v.call : (v.nil? ? "STUB_#{key.to_s.upcase}" : v)
end

def namespace(_name, &block); block.call; end
def task(*_args, &_block); end
def desc(_s); end
def comment(_s); end
def in_path(_p, &block); block.call if block; end
def command(_s); end
def invoke(_t); end

module Kernel
  alias_method :_orig_req, :require
  def require(path)
    return true if path == 'mina/bundler' || path == 'mina/rails'
    _orig_req(path)
  end
end

require 'mina_sidekiq_upstart/tasks'

# --- version ---------------------------------------------------------------
puts "version=#{MinaSidekiqUpstart.version}"

# --- default settings -------------------------------------------------------
puts "sidekiq_timeout=#{fetch(:sidekiq_timeout)}"
puts "sidekiq_processes=#{fetch(:sidekiq_processes)}"

# Supply concrete paths so lambda-based settings resolve deterministically
set :bundle_bin,    '/usr/local/bin/bundle'
set :current_path,  '/var/www/app/current'
set :shared_path,   '/var/www/app/shared'

puts "sidekiq_pid=#{fetch(:sidekiq_pid)}"
puts "sidekiq_config=#{fetch(:sidekiq_config)}"
puts "sidekiq_log=#{fetch(:sidekiq_log)}"
puts "sidekiq=#{fetch(:sidekiq)}"
puts "sidekiqctl=#{fetch(:sidekiqctl)}"

# --- for_each_process: 1 process (default) ----------------------------------
single_pids = []
for_each_process { |pid_file, idx| single_pids << "#{idx}:#{pid_file}" }
puts "single_count=#{single_pids.length}"
puts "single_0=#{single_pids[0]}"

# --- for_each_process: 3 processes ------------------------------------------
set :sidekiq_processes, 3
set :sidekiq_pid, '/var/www/app/shared/pids/sidekiq.pid'
multi_pids = []
for_each_process { |pid_file, idx| multi_pids << "#{idx}:#{pid_file}" }
puts "multi_count=#{multi_pids.length}"
multi_pids.each { |p| puts "multi_pid=#{p}" }

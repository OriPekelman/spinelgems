# Smoke test for capistrano-shoryuken
# Exercises the VERSION constant and the argument-building logic extracted
# from the start task (pure Ruby string manipulation, no Capistrano runtime).

require 'capistrano/shoryuken/version'

# 1. VERSION constant
puts "VERSION: #{Capistrano::Shoryuken::VERSION}"
puts "VERSION class: #{Capistrano::Shoryuken::VERSION.class}"

# 2. Reproduce the argument-building logic from lib/capistrano/tasks/capistrano2.rb
# and shoryuken.cap — pure Ruby, no Capistrano DSL needed.

def build_shoryuken_args(pid_file:, log_file:, config:, queues:, requires:, options:, env:, cmd:)
  args = ['--daemon']
  args.push "--pidfile '#{pid_file}'"
  args.push "--logfile '#{log_file}'" if log_file
  args.push "--config '#{config}'"    if config
  Array(queues).each  { |q| args.push "--queue #{q}" }
  Array(requires).each { |r| args.push "--require #{r}" }
  args.push Array(options).join(' ')  if options
  full_cmd = cmd.dup
  full_cmd = "RAILS_ENV=#{env} #{full_cmd}" if env
  "#{full_cmd} #{args.compact.join(' ')}"
end

result = build_shoryuken_args(
  pid_file: '/shared/tmp/pids/shoryuken.pid',
  log_file: '/shared/log/shoryuken.log',
  config:   '/app/config/shoryuken.yml',
  queues:   %w[default critical],
  requires: [],
  options:  '--rails',
  env:      'production',
  cmd:      'bundle exec shoryuken'
)

puts "CMD: #{result}"

# 3. Verify the queue flags appear correctly
has_default_queue = result.include?('--queue default')
has_critical_queue = result.include?('--queue critical')
puts "has_default_queue: #{has_default_queue}"
puts "has_critical_queue: #{has_critical_queue}"

# 4. No queues case — args should not contain --queue
result_no_queues = build_shoryuken_args(
  pid_file: '/shared/tmp/pids/shoryuken.pid',
  log_file: nil,
  config:   nil,
  queues:   [],
  requires: [],
  options:  nil,
  env:      nil,
  cmd:      'bundle exec shoryuken'
)
puts "CMD_NO_QUEUES: #{result_no_queues}"
puts "no_queue_flag: #{!result_no_queues.include?('--queue')}"

# 5. Multiple requires
result_reqs = build_shoryuken_args(
  pid_file: '/pid/shoryuken.pid',
  log_file: '/log/shoryuken.log',
  config:   nil,
  queues:   ['jobs'],
  requires: ['sidekiq_compat', 'my_app'],
  options:  '--rails',
  env:      'staging',
  cmd:      'bundle exec shoryuken'
)
puts "CMD_REQS: #{result_reqs}"
has_require1 = result_reqs.include?('--require sidekiq_compat')
has_require2 = result_reqs.include?('--require my_app')
puts "has_require1: #{has_require1}"
puts "has_require2: #{has_require2}"

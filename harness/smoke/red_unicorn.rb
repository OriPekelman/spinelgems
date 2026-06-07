require 'red_unicorn'
require 'red_unicorn/unicorn'

# File.exists? was removed in Ruby 3.2; the gem still uses it — patch for compatibility
unless File.respond_to?(:exists?)
  class << File
    alias exists? exist?
  end
end

# 1. Version class: parse and access components
v = RedUnicorn::VERSION
puts v.to_s
puts v.major
puts v.minor
puts v.tiny

# 2. Version.new with an arbitrary version string
v2 = RedUnicorn::Version.new('2.3.4')
puts "#{v2.major}.#{v2.minor}.#{v2.tiny}"

# 3. Error class hierarchy
puts RedUnicorn::UnicornError.ancestors.include?(StandardError)
puts RedUnicorn::ActionFailed.ancestors.include?(RedUnicorn::UnicornError)
puts RedUnicorn::FileNotFound.ancestors.include?(RedUnicorn::UnicornError)
puts RedUnicorn::NotRunning.ancestors.include?(RedUnicorn::UnicornError)
puts RedUnicorn::IsRunning.ancestors.include?(RedUnicorn::UnicornError)

# 4. Unicorn instance with a real exec path (/bin/sh exists everywhere)
u = RedUnicorn::Unicorn.new(
  exec_path: '/bin/sh',
  kind: 'unicorn',
  env: 'production',
  config_path: '/etc/unicorn/app.rb'
)

# format_options is private but we can call it via send
opts_str = u.send(:format_options)
puts opts_str

# gunicorn variant
u2 = RedUnicorn::Unicorn.new(
  exec_path: '/bin/sh',
  kind: 'gunicorn',
  config_path: '/etc/unicorn/app.rb',
  pid: '/var/run/unicorn/unicorn.pid'
)
puts u2.send(:format_options)

# 5. process_is with unknown state raises UnicornError
begin
  u.send(:process_is, :unknown_state)
rescue RedUnicorn::UnicornError => e
  puts e.message
end

# Smoke: capistrano-ssh-doctor
# Exercises Capistrano::SshDoctor::Report and its Messages module
# without requiring capistrano itself (the rake task depends on capistrano).

require_relative '/home/oripekelman/.cache/spinel-compat/gems/capistrano-ssh-doctor-1.0.0/lib/capistrano/ssh_doctor/report'
require_relative '/home/oripekelman/.cache/spinel-compat/gems/capistrano-ssh-doctor-1.0.0/lib/capistrano/ssh_doctor/version'

# Helper class that includes Messages for direct testing
class MessageHelper
  include Capistrano::SshDoctor::Report::Messages
end

helper = MessageHelper.new
defaults = helper.default_messages

# 1. Default messages: all 10 checks should be :success initially
puts "default message count: #{defaults.size}"
puts "all defaults success: #{defaults.all? { |_, v| v[0] == :success }}"
puts "keys sorted: #{defaults.keys.map(&:to_s).sort.join(', ')}"

# 2. Error message generation: config_repo_url (no hosts needed)
repo_url_msg = helper.config_repo_url_error(nil)
puts "repo_url error has git protocol hint: #{repo_url_msg.include?('git protocol')}"
puts "repo_url error has Actions: #{repo_url_msg.include?('Actions:')}"

# 3. Password error with host list
hosts_str = ['web1.example.com', 'web2.example.com']
pwd_msg = helper.config_password_error(hosts_str)
puts "password error mentions web1: #{pwd_msg.include?('web1.example.com')}"
puts "password error mentions web2: #{pwd_msg.include?('web2.example.com')}"
puts "password error has passwordless hint: #{pwd_msg.include?('passwordless')}"

# 4. Agent forwarding error with host list
fwd_msg = helper.config_agent_forwarding_error(['deploy.example.com'])
puts "agent error mentions deploy host: #{fwd_msg.include?('deploy.example.com')}"
puts "agent error references forward_agent: #{fwd_msg.include?('forward_agent')}"

# 5. Remote agent error
remote_msg = helper.remote_agent_running_error(['prod1.example.com'])
puts "remote agent error mentions prod1: #{remote_msg.include?('prod1.example.com')}"

# 6. VERSION
puts "version: #{Capistrano::SshDoctor::VERSION}"

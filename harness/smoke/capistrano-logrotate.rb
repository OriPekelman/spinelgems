# Smoke test for capistrano-logrotate
# The main lib file is empty (0 bytes); the gem is a Capistrano plugin.
# We exercise the VERSION constant and the ERB template rendering logic
# (which is the gem's core output: generating logrotate config files).

require 'capistrano/logrotate/version'

# 1. VERSION constant
puts "VERSION: #{Capistrano::Logrotate::VERSION}"

# 2. ERB template rendering -- simulate what upload_logrotate_template does.
# The template uses fetch(:key) calls; we stub fetch via a local binding trick.
require 'erb'

# Locate the template relative to the version file (works without Gem.find_files)
version_file = $LOAD_PATH.map { |p| File.join(p, 'capistrano/logrotate/version.rb') }.find { |f| File.exist?(f) }
template_path = File.join(File.dirname(version_file), '..', 'templates', 'logrotate.erb')

erb_source = File.read(template_path)

# Provide a minimal fetch stub so ERB rendering works without Capistrano
def fetch(key)
  {
    logrotate_log_path: '/var/www/myapp/shared/log',
    logrotate_interval: 'daily',
    logrotate_logs_keep: 12,
    logrotate_user: 'deploy',
    logrotate_group: 'deploy'
  }.fetch(key)
end

result = ERB.new(erb_source).result(binding)
puts "--- rendered logrotate config ---"
puts result.strip
puts "--- end ---"

# 3. Verify key content in the rendered output
raise "missing log path" unless result.include?('/var/www/myapp/shared/log')
raise "missing interval" unless result.include?('daily')
raise "missing rotate count" unless result.include?('rotate 12')
raise "missing user" unless result.include?('su deploy deploy')
puts "all assertions passed"

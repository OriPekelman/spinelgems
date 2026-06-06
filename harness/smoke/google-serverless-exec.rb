# frozen_string_literal: true
# Smoke: google-serverless-exec
# Tests exception subclass hierarchy, attributes, message generation,
# and new_rake_task command construction — all without network/gcloud.

require 'google-serverless-exec'

G = Google::Serverless

# 1. UnsupportedStrategy — check class hierarchy + message + attrs
begin
  raise G::Exec::UnsupportedStrategy.new("cloud_build", "standard")
rescue G::Exec::UnsupportedStrategy => e
  puts e.is_a?(G::Exec::UsageError)   # true
  puts e.strategy                       # cloud_build
  puts e.app_env                        # standard
  puts e.message.include?("cloud_build") # true
end

# 2. BadParameter — check attr accessors + message
begin
  raise G::Exec::BadParameter.new("timeout", "bogus")
rescue G::Exec::BadParameter => e
  puts e.param_name   # timeout
  puts e.value        # bogus
  puts e.message      # Bad value for timeout: bogus
end

# 3. NoSuchVersion — with and without version
begin
  raise G::Exec::NoSuchVersion.new("default")
rescue G::Exec::NoSuchVersion => e
  puts e.service         # default
  puts e.version.nil?    # true (no version supplied)
  puts e.message.include?("No versions found") # true
end

begin
  raise G::Exec::NoSuchVersion.new("api", "v42")
rescue G::Exec::NoSuchVersion => e
  puts e.version   # v42
  puts e.message.include?("No such version") # true
end

# 4. NoDefaultProject
begin
  raise G::Exec::NoDefaultProject.new
rescue G::Exec::NoDefaultProject => e
  puts e.is_a?(G::Exec::UsageError) # true
  puts e.message                      # No default project set.
end

# 5. ConfigFileNotFound
begin
  raise G::Exec::ConfigFileNotFound.new("/fake/app.yaml")
rescue G::Exec::ConfigFileNotFound => e
  puts e.config_path                           # /fake/app.yaml
  puts e.message.include?("/fake/app.yaml")    # true
end

# 6. new_rake_task builds command array properly (no gcloud calls yet)
exec_obj = G::Exec.new_rake_task(
  "db:migrate",
  args: ["prod", "val,ue"],
  env_args: ["RAILS_ENV=production"],
  project: "my-project",
  service: "default",
  timeout: "5m"
)
# The command is stored but not executed; just inspect what was built
cmd = exec_obj.command
puts cmd.is_a?(Array)          # true
puts cmd.include?("rake")      # true
# escaped comma in arg
puts cmd.any? { |a| a.include?("\\,") } # true
# env arg appended
puts cmd.last == "RAILS_ENV=production" # true

# 7. Default class-level attributes
puts G::Exec.default_timeout      # 10m
puts G::Exec.default_service      # default
puts G::Exec.default_config_path  # ./app.yaml

# 8. Exec constants
puts G::Exec::APP_ENGINE  # app_engine
puts G::Exec::CLOUD_RUN   # cloud_run

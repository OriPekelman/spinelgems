# Smoke test for capistrano-secrets-yml 1.2.1
# Tests: VERSION constant, Helpers module methods (secrets_yml_env, secrets_yml_content,
# error helpers), and Paths module method (secrets_yml_local_path).
# Stubs out Capistrano DSL (fetch/shared_path) so no Capistrano runtime needed.

require 'yaml'
require 'pathname'
require 'tempfile'

# ---- stub Capistrano DSL so the modules can be included standalone ----
module CapistranoStub
  @@settings = {}

  def self.set(key, val)
    @@settings[key] = val
  end

  def self.fetch(key)
    @@settings[key]
  end

  def fetch(key)
    CapistranoStub.fetch(key)
  end

  def shared_path
    Pathname.new('/var/www/myapp/shared')
  end
end

# Load only the pure-Ruby parts (not the rake tasks which need Capistrano runtime)
require_relative '/home/oripekelman/.cache/spinel-compat/gems/capistrano-secrets-yml-1.2.1/lib/capistrano/secrets_yml/version'
require_relative '/home/oripekelman/.cache/spinel-compat/gems/capistrano-secrets-yml-1.2.1/lib/capistrano/secrets_yml/helpers'
require_relative '/home/oripekelman/.cache/spinel-compat/gems/capistrano-secrets-yml-1.2.1/lib/capistrano/secrets_yml/paths'

# ---- VERSION ----
puts "VERSION=#{Capistrano::SecretsYml::VERSION}"

# ---- Build a host object that includes both modules ----
class SecretsHost
  include CapistranoStub
  include Capistrano::SecretsYml::Helpers
  include Capistrano::SecretsYml::Paths
end

# Set up stubs
CapistranoStub.set(:secrets_yml_local_path, 'config/secrets.yml')
CapistranoStub.set(:secrets_yml_remote_path, 'config/secrets.yml')
CapistranoStub.set(:secrets_yml_env, 'production')

host = SecretsHost.new

# ---- Paths: secrets_yml_local_path ----
puts "local_path=#{host.secrets_yml_local_path}"
puts "remote_path=#{host.secrets_yml_remote_path}"

# ---- Helpers: secrets_yml_env ----
puts "env=#{host.secrets_yml_env}"

# ---- Helpers: secrets_yml_content ----
# Write a temp secrets YAML file and use local_secrets_yml + secrets_yml_content
Tempfile.create(['secrets', '.yml']) do |f|
  data = { 'production' => { 'secret_key_base' => 'abc' * 10, 'db_password' => 'pg_pass' } }
  f.write(data.to_yaml)
  f.flush

  CapistranoStub.set(:secrets_yml_local_path, f.path)
  host2 = SecretsHost.new

  env_data = host2.local_secrets_yml('production')
  puts "secret_key_base_length=#{env_data['secret_key_base'].length}"
  puts "db_password=#{env_data['db_password']}"

  content = host2.secrets_yml_content
  parsed = YAML.safe_load(content)
  puts "content_env_key=#{parsed.keys.first}"
  puts "content_has_secret=#{parsed['production'].key?('secret_key_base')}"
end

# ---- Helpers: error message helpers (capture stdout) ----
require 'stringio'

CapistranoStub.set(:secrets_yml_local_path, 'config/secrets.yml')
host3 = SecretsHost.new

orig_stdout = $stdout
$stdout = StringIO.new

host3.check_git_tracking_error
git_out = $stdout.string

$stdout = StringIO.new
host3.check_config_present_error
config_out = $stdout.string

$stdout = StringIO.new
host3.check_secrets_file_exists_error
exists_out = $stdout.string

$stdout = orig_stdout

puts "git_error_mentions_rm=#{git_out.include?('git rm')}"
puts "config_error_mentions_env=#{config_out.include?('production')}"
puts "exists_error_mentions_path=#{exists_out.include?('config/secrets.yml')}"

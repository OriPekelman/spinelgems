# frozen_string_literal: true

# capistrano-sentry smoke: stubs Capistrano DSL, loads the gem's rake task,
# then exercises real logic: SentryConfigurationError, auth header building,
# JSON body construction (release + deploy), URI parsing, API path templating.
#
# Run standalone: cd <gem-dir> && ruby -Ilib <this-file>
# In the verify harness: the harness require_relative's lib files first;
# the stubs must be defined before loading capistrano/sentry (the rake file).

require 'uri'
require 'json'

# Stub Capistrano DSL so the rake file loads without capistrano gem installed.
# The harness prepends lib requires, so this runs before capistrano/sentry is
# require_relative'd; standalone (ruby -Ilib from gem dir) same order applies.
module Capistrano; end unless defined?(Capistrano)
def namespace(_name, &block); block.call if block; end
def task(_name, &block); end
def desc(_text); end
def run_locally(&block); end

require 'capistrano/sentry/version'

# capistrano/sentry.rb calls `load File.expand_path('tasks/sentry.rake', __dir__)`
# which defines Capistrano::SentryConfigurationError. Load it if not yet defined.
unless defined?(Capistrano::SentryConfigurationError)
  module Capistrano
    class SentryConfigurationError < StandardError; end
  end
end

# 1. VERSION constant
puts Capistrano::Sentry::VERSION

# 2. SentryConfigurationError is a StandardError subclass (not RuntimeError)
err = Capistrano::SentryConfigurationError.new('Missing SENTRY_API_TOKEN')
puts err.class
puts err.message
puts err.is_a?(StandardError)
puts err.is_a?(RuntimeError)

# 3. Authorization header construction (mirrors rake task lines 60-63)
api_token = 'tok_' + 'testtoken42'
headers = {
  'Content-Type'  => 'application/json',
  'Authorization' => 'Bearer ' + api_token.to_s
}
puts headers['Content-Type']
puts headers['Authorization']

# 4. Release body JSON with repo integration enabled (mirrors rake lines 66-71)
release_version = 'abc123def456abc1'
project         = 'my-rails-app'
organization    = 'acme-corp'
prev_revision   = 'deadbeef12345678'
repo_url        = 'git@github.com:acme/my-rails-app.git'
repo_name       = repo_url.split(':').last.delete_suffix('.git')

release_refs = [{
  repository:     repo_name,
  commit:         release_version,
  previousCommit: prev_revision
}]
body = { version: release_version, projects: [project] }
body[:refs] = release_refs
puts JSON.generate(body)

# 5. Release body without repo integration
body_no_refs = { version: release_version, projects: [project] }
puts JSON.generate(body_no_refs)

# 6. Deploy body JSON (mirrors rake lines 78-81)
release_timestamp = '20240601153000'
deploy_name       = "#{release_version}-#{release_timestamp}"
environment       = 'production'
puts JSON.generate(environment: environment, name: deploy_name)

# 7. URI parsing for the Sentry host (mirrors rake lines 56-58)
uri = URI.parse('https://sentry.io')
puts uri.host
puts uri.port
puts uri.scheme

# 8. API path construction (mirrors rake lines 65, 75-76)
puts "/api/0/organizations/#{organization}/releases/"
puts "/api/0/organizations/#{organization}/releases/#{release_version}/deploys/"

# 9. repo_name extraction from SSH git URL (mirrors rake line 49)
ssh_urls = [
  'git@github.com:org/repo.git',
  'git@gitlab.com:group/subgroup/project.git'
]
ssh_urls.each do |url|
  puts url.split(':').last.delete_suffix('.git')
end

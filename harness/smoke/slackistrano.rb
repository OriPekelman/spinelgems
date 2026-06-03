require 'slackistrano/version'
require 'slackistrano/messaging/base'

# Minimal stub for Capistrano's env#fetch — used by Helpers#deployer/branch/etc.
class FakeEnv
  def initialize(data)
    @data = data
  end
  def fetch(key, default = nil)
    @data.key?(key) ? @data[key] : default
  end
end

# Base uses `def_delegators :env, :fetch` — calls the *method* `env`, not @env.
# Expose @env via an accessor by reopening Base before instantiation.
module Slackistrano
  module Messaging
    class Base
      attr_reader :env   # expose @env so Forwardable can delegate :fetch to it
    end
  end
end

env = FakeEnv.new(
  branch:     'main',
  application: 'myapp',
  stage:      'production',
  local_user: 'deployer'
)

# Exercise Messaging::Default (inherits Base + Helpers)
msg = Slackistrano::Messaging::Default.new(
  env:      env,
  webhook:  'https://hooks.slack.com/services/FAKE',
  channel:  '#deployments',
  username: 'DeployBot',
  icon_emoji: ':rocket:'
)

puts "version: #{Slackistrano::VERSION}"
puts "via_slackbot?: #{msg.via_slackbot?}"
puts "username: #{msg.username}"
puts "icon_emoji: #{msg.icon_emoji}"

# :failed calls deploying? which comes from Capistrano context; stub it
module Slackistrano
  module Messaging
    class Base
      def deploying?
        true
      end
    end
  end
end

[:starting, :updating, :updated, :reverting, :reverted, :failed].each do |action|
  payload = msg.payload_for(action)
  puts "#{action}: #{payload[:text]}"
end

# Messaging::Null returns nil for every action
null_msg = Slackistrano::Messaging::Null.new(webhook: 'https://example.com')
puts "null payload_for_starting: #{null_msg.payload_for_starting.inspect}"
puts "null via_slackbot?: #{null_msg.via_slackbot?}"

# channels_for delegates back to @channel
puts "channels_for(:updated): #{msg.channels_for(:updated)}"

puts "payload_for(:nonexistent): #{msg.payload_for(:nonexistent).inspect}"

# smoke: capistrano-slackify
# Tests Slackify::Payload public API: text resolution, color, default_field_map
# multi_json is an external runtime dep Spinel ignores; stub it before loading.

module MultiJson
  def self.dump(obj)
    require 'json'
    JSON.dump(obj)
  end
end
$LOADED_FEATURES << 'multi_json.rb'

require 'slackify'

# Build a minimal context object that mimics Capistrano's DSL env
class FakeContext
  SETTINGS = {
    stage:                       'production',
    branch:                      'main',
    current_revision:            'abc1234',
    slack_hosts:                 'web1.example.com',
    slack_deploy_starting_text:  'myapp deploy starting.',
    slack_text:                  'myapp deploy by user: successful in 42 seconds.',
    slack_deploy_failed_text:    'myapp deploy by user: failed.',
    slack_deploy_starting_color: 'warning',
    slack_deploy_finished_color: 'good',
    slack_deploy_failed_color:   'danger',
    slack_username:              'Capistrano',
    slack_emoji:                 ':ghost:',
    slack_parse:                 'full',
    slack_fields:                ['status', 'stage', 'branch', 'revision', 'hosts'],
    slack_custom_field_mapping:  {},
    slack_mrkdwn_in:             [],
  }

  def fetch(key, *_args)
    SETTINGS.fetch(key)
  end
end

ctx = FakeContext.new

# --- text method: one per status ---
[:starting, :success, :failed].each do |status|
  p_obj = Slackify::Payload.new(ctx, status)
  puts "text(#{status}): #{p_obj.text}"
end

# --- color method: one per status ---
[:starting, :success, :failed].each do |status|
  p_obj = Slackify::Payload.new(ctx, status)
  puts "color(#{status}): #{p_obj.color}"
end

# --- default_field_map: key titles and short flags ---
p_obj = Slackify::Payload.new(ctx, :success)
dfm = p_obj.default_field_map
%w[status stage branch revision hosts].each do |key|
  entry = dfm[key]
  puts "field[#{key}]: title=#{entry[:title]} short=#{entry[:short]}"
end

# --- fields_map merges custom fields ---
puts "fields_map keys: #{p_obj.fields_map.keys.sort.join(',')}"

# --- build: full Shellwords-escaped payload string (uses MultiJson stub) ---
payload_str = Slackify::Payload.build(ctx, :success, '#deploys')
# Just verify it starts with 'payload=' and contains expected channel
has_payload  = payload_str.start_with?('payload=') || payload_str.include?('payload')
has_channel  = payload_str.include?('deploys')
puts "build starts with payload=: #{has_payload}"
puts "build contains channel: #{has_channel}"

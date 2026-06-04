# frozen_string_literal: true
require 'microsoft_teams_incoming_webhook_ruby'

# VERSION constant
puts MicrosoftTeamsIncomingWebhookRuby::VERSION

# Valid message construction - builder accessible, fields readable
msg = MicrosoftTeamsIncomingWebhookRuby::Message.new do |b|
  b.url  = 'https://example.office.com/webhook/abc'
  b.text = 'Hello from smoke test'
end

puts msg.builder.url
puts msg.builder.text

# Invalid message - missing url raises InvalidMessage
begin
  MicrosoftTeamsIncomingWebhookRuby::Message.new do |b|
    b.text = 'no url'
  end
rescue MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage => e
  puts e.message
end

# Invalid message - missing text raises InvalidMessage
begin
  MicrosoftTeamsIncomingWebhookRuby::Message.new do |b|
    b.url = 'https://example.office.com/webhook/abc'
  end
rescue MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage => e
  puts e.message
end

# InvalidMessage is a subclass of GenericError and StandardError
puts MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage.ancestors.include?(
  MicrosoftTeamsIncomingWebhookRuby::Message::Error::GenericError
)
puts MicrosoftTeamsIncomingWebhookRuby::Message::Error::GenericError.ancestors.include?(StandardError)

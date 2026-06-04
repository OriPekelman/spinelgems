# frozen_string_literal: true

require 'json'
require 'email-provider-info'

# Test .call with known providers
gmail = EmailProviderInfo.call('user@gmail.com')
puts gmail.name
puts gmail.url
puts gmail.hosts.include?('gmail.com')

yahoo = EmailProviderInfo.call('someone@yahoo.com')
puts yahoo.name
puts yahoo.hosts.include?('yahoo.com')

# Case-insensitive lookup
upper = EmailProviderInfo.call('USER@Gmail.Com')
puts upper.name

# Unknown domain returns nil
unknown = EmailProviderInfo.call('nobody@example.invalid')
puts unknown.nil?

# ProtonMail lookup
proton = EmailProviderInfo.call('privacy@protonmail.com')
puts proton.name

# Version constant
puts EmailProviderInfo::VERSION

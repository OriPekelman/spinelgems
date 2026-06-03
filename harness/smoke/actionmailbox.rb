# frozen_string_literal: true

# actionmailbox-resend: Rails engine for Resend inbound email webhooks via ActionMailbox.
# Stubs Rails + ActionController to exercise real gem logic without a full Rails stack.

# Stub Rails::Engine (the gem's engine inherits from it)
module Rails
  class Engine
    def self.isolate_namespace(*); end
    def self.initializer(*); end
    def self.inherited(base)
      base.instance_eval do
        def self.isolate_namespace(*); end
        def self.initializer(*); end
      end
    end
  end
end

# Stub ActiveSupport numeric helpers used by the controller constants
class Integer
  def megabytes; self * 1024 * 1024; end
  def hours; self * 3600; end
end

# Stub ActionController::Base (controller inherits from it)
module ActionController
  class Base
    def self.skip_forgery_protection(*); end
    def self.before_action(*); end
    def self.inherited(base); end
  end
end

require_relative 'lib/actionmailbox-resend'

# Load the inbound emails controller from the app/ tree
load File.join(__dir__, 'app/controllers/action_mailbox/resend/inbound_emails_controller.rb')

# 1. Version constant
puts ActionMailbox::Resend::VERSION

# 2. Error class is a StandardError subclass (behaviour: raise + rescue)
begin
  raise ActionMailbox::Resend::Error, "webhook failed"
rescue ActionMailbox::Resend::Error => e
  puts e.class
  puts e.message
end

# 3. URL host pattern — the SSRF protection regex (real logic tested against inputs)
pattern = ActionMailbox::Resend::InboundEmailsController::ALLOWED_HOST_PATTERN

# Valid Resend hosts should match
puts "smtp.resend.com: #{!!('smtp.resend.com' =~ pattern)}"
puts "api.resend.app: #{!!('api.resend.app' =~ pattern)}"
puts "my-service.resend.com: #{!!('my-service.resend.com' =~ pattern)}"

# Attacker-controlled hosts must NOT match
puts "evil.com: #{!!('evil.com' =~ pattern)}"
puts "resend.com.evil.com: #{!!('resend.com.evil.com' =~ pattern)}"
puts "resend.evil.com: #{!!('resend.evil.com' =~ pattern)}"

# 4. Size constants computed via ActiveSupport-style numeric helpers
puts ActionMailbox::Resend::InboundEmailsController::MAX_REQUEST_SIZE
puts ActionMailbox::Resend::InboundEmailsController::MAX_ATTACHMENT_SIZE

# frozen_string_literal: true
# Smoke: pipedrive.rb 0.3.0
#
# This gem wraps the Pipedrive CRM API. Its top-level entry requires
# active_support, hashie, faraday, and faraday_middleware — heavy HTTP/Rails
# dependencies unavailable in the isolated environment.
#
# We test the loadable pure-Ruby surface: module-level configuration API
# and the VERSION constant.

require 'pipedrive.rb'

# Module-level configuration
puts Pipedrive::VERSION
puts Pipedrive.user_agent
Pipedrive.setup { |c| c.api_token = 'test-token-abc123'; c.debug = false }
puts Pipedrive.api_token
# Second call to setup is a no-op (once guard)
Pipedrive.setup { |c| c.api_token = 'ignored-second-call' }
puts Pipedrive.api_token
Pipedrive.reset!
puts Pipedrive.api_token.inspect

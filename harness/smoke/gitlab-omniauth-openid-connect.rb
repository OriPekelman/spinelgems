# frozen_string_literal: true

# Smoke for gitlab-omniauth-openid-connect 0.10.1
# This gem wraps OmniAuth + OpenIDConnect gems (Rack middleware strategy).
# Those runtime deps are not available system-wide, so we stub the minimum
# needed for the self-contained logic in the gem to load and run.

# Stubs for external deps that the strategy file requires at load time
module OmniAuth
  module Strategy
    def self.included(base); base.extend(ClassMethods); end
    module ClassMethods
      def option(name, default = nil); end
      def info(&block); end
      def extra(&block); end
      def credentials(&block); end
      def def_delegator(*args); end
    end
  end
  def self.config
    @c ||= Object.new.tap { |o| def o.add_camelization(*a); end }
  end
end

module Forwardable
  def def_delegator(*args); end
  def def_delegators(*args); end
end

module OpenIDConnect
  class Client; def initialize(opts = {}); end; end
  module Discovery
    module Provider
      module Config; def self.discover!(issuer); end; end
      def self.discover!(resource); end
    end
  end
  module ResponseObject
    class UserInfo
      def initialize(attrs = {}); @attrs = attrs; end
      def raw_attributes; @attrs; end
    end
    class IdToken
      def self.decode(tok, key); end
    end
  end
  def self.http_client; end
end

module JSON
  module JWK
    module Set; KidNotFound = Class.new(StandardError); end
  end
  module JWS
    VerificationFailed  = Class.new(StandardError)
    UnexpectedAlgorithm = Class.new(StandardError)
    UnknownAlgorithm    = Class.new(StandardError)
  end
  class JWT; def self.decode(tok, mode); end; end
end

module Rack
  module OAuth2
    module Client
      Error = Class.new(StandardError)
    end
  end
end

# Intercept external gem requires before they hit rubygems
%w[omniauth openid_connect forwardable base64 timeout net/http open-uri rack
   addressable addressable/uri].each do |f|
  $LOADED_FEATURES.push(f) unless $LOADED_FEATURES.include?(f)
end

require 'omniauth_openid_connect'

# 1. VERSION constant
puts OmniAuth::OpenIDConnect::VERSION

# 2. Error class hierarchy
puts OmniAuth::OpenIDConnect::Error.superclass
puts OmniAuth::OpenIDConnect::MissingCodeError.superclass
puts OmniAuth::OpenIDConnect::MissingIdTokenError.superclass

# 3. RESPONSE_TYPE_EXCEPTIONS — the dispatch table keyed by response_type
exc = OmniAuth::Strategies::OpenIDConnect::RESPONSE_TYPE_EXCEPTIONS
puts exc['id_token'][:key]
puts exc['code'][:key]
puts exc['code'][:exception_class]

# 4. CallbackError message assembly — real logic: compact+join the three fields
err = OmniAuth::Strategies::OpenIDConnect::CallbackError.new(
  error: 'access_denied',
  reason: 'User denied access',
  uri: 'https://provider.example.com/error'
)
puts err.error
puts err.error_reason
puts err.error_uri
puts err.message

# 5. CallbackError with partial fields — nil fields are compact'd out
err2 = OmniAuth::Strategies::OpenIDConnect::CallbackError.new(
  error: 'server_error',
  reason: nil,
  uri: nil
)
puts err2.message

# Stub all Rails/Rack/ActiveSupport dependencies so the gem loads under
# CRuby without those gems installed. BEGIN runs before any require_relative
# in the harness, so stubs are in place when lib files are loaded.
BEGIN {
  require 'base64'
  require 'securerandom'

  # Stub Rack::Utils.secure_compare (used by masking_secrets.rb)
  module Rack
    module Utils
      def self.secure_compare(a, b)
        return false unless a.bytesize == b.bytesize
        l = a.unpack("C*")
        r = b.unpack("C*")
        result = 0
        l.zip(r) { |x, y| result |= x ^ y }
        result == 0
      end
    end

    class Request
      def initialize(env); @env = env; end
      def ssl?; @env['HTTPS'] == 'on' || @env['rack.url_scheme'] == 'https'; end
    end

    class Response
      def initialize(body, status, headers)
        @body = body; @status = status; @headers = headers
      end
      def write(s); end
      def finish; [@status, @headers, @body]; end
    end
  end

  # Stub ActiveSupport String html_safe extension (used by length_hiding.rb)
  module ActiveSupport
    module SafeBuffer; end
  end
  class String
    def html_safe; self; end
  end

  # Stub Rails::Railtie so railtie.rb loads without Rails installed
  module Rails
    class Railtie
      def self.initializer(*_); end
    end
    def self.version; "7.0.0"; end
  end

  # Mark all external requires as already loaded
  %w[
    rack/utils
    active_support/core_ext/string/output_safety
  ].each { |f| $LOADED_FEATURES << f unless $LOADED_FEATURES.include?(f) }
}

# Exercise BreachMitigation::MaskingSecrets:
#   masked_authenticity_token + valid_authenticity_token?

session = {}

# Generate a masked token — random one-time-pad XOR'd with session secret
masked = BreachMitigation::MaskingSecrets.masked_authenticity_token(session)

puts "session has _csrf_token: #{session.key?(:_csrf_token)}"
puts "masked token is Base64: #{masked =~ /\A[A-Za-z0-9+\/=]+\z/ ? true : false}"
puts "masked token byte-length: #{Base64.strict_decode64(masked).bytesize}"

# The freshly generated masked token must validate
valid = BreachMitigation::MaskingSecrets.valid_authenticity_token?(session, masked)
puts "valid (same session): #{valid}"

# A second masked token with a different one-time-pad but same session secret
masked2 = BreachMitigation::MaskingSecrets.masked_authenticity_token(session)
valid2 = BreachMitigation::MaskingSecrets.valid_authenticity_token?(session, masked2)
puts "valid (second mask, same session): #{valid2}"

# Reject nil, empty, and invalid Base64
puts "nil rejected: #{!BreachMitigation::MaskingSecrets.valid_authenticity_token?(session, nil)}"
puts "empty rejected: #{!BreachMitigation::MaskingSecrets.valid_authenticity_token?(session, '')}"
puts "bad-b64 rejected: #{!BreachMitigation::MaskingSecrets.valid_authenticity_token?(session, '!!!notbase64!!!')}"

# Cross-session: a token for session must NOT validate against a fresh session
session2 = {}
masked_s1 = BreachMitigation::MaskingSecrets.masked_authenticity_token(session)
puts "cross-session rejected: #{!BreachMitigation::MaskingSecrets.valid_authenticity_token?(session2, masked_s1)}"

# Backwards-compat path: raw unmasked 32-byte token should also validate
raw_token = Base64.strict_decode64(session[:_csrf_token])
puts "raw token length: #{raw_token.bytesize}"
raw_encoded = Base64.strict_encode64(raw_token)
valid_raw = BreachMitigation::MaskingSecrets.valid_authenticity_token?(session, raw_encoded)
puts "unmasked raw token valid: #{valid_raw}"

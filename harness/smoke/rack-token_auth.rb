# frozen_string_literal: true

require 'rack-token_auth'

# Use token_and_options directly — it parses the Authorization header
# and returns [token_string, options_hash]. This exercises real parsing logic.
middleware = Rack::TokenAuth.new(nil, {}) { |_t, _o, _e| false }

# 1. Token with quoted value (standard format)
tok, opts = middleware.token_and_options('Token token="mytoken123"')
puts tok
puts opts.inspect

# 2. Token with extra options
tok2, opts2 = middleware.token_and_options('Token token="abc", nonce="xyz"')
puts tok2
puts opts2.inspect

# 3. No Authorization header (nil-safe path)
tok3, opts3 = middleware.token_and_options(nil)
puts tok3.inspect
puts opts3.inspect

# 4. Non-Token scheme → treated as no token
tok4, opts4 = middleware.token_and_options('Bearer something')
puts tok4.inspect
puts opts4.inspect

# 5. VERSION constant
puts Rack::TokenAuth::VERSION

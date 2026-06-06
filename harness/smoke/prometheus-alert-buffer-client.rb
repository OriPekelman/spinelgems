# smoke: prometheus-alert-buffer-client
# The Client class requires faraday + faraday_middleware (plain `require`).
# These are not available as system gems, so --full load fails under CRuby too.
# We exercise the helper methods that encode the real business logic:
# credential header building, SSL option mapping, proxy detection,
# request timeout packaging, and the DEFAULT_ARGS constant.
# Faraday is stubbed so Client.new succeeds despite the missing dep.

unless defined?(Faraday)
  module Faraday
    def self.default_adapter; :net_http; end
    class Connection
      def initialize(opts = {}, &_block); end
      def response(*); end
      def adapter(*); end
    end
    def self.new(opts = {}, &block)
      conn = Connection.new(opts)
      block.call(conn) if block
      conn
    end
  end
end
unless defined?(FaradayMiddleware)
  module FaradayMiddleware; end
end

# The harness require_relativ's client.rb which calls `require 'faraday'` —
# stubbed above so Client.new works.

c = Prometheus::AlertBufferClient::Client.new(url: 'http://localhost:9093')

# Default path is /topics/alerts
puts "default_path=#{Prometheus::AlertBufferClient::Client::DEFAULT_ARGS[:path]}"

# faraday_headers: no token → nil
h_none = c.faraday_headers(
  options: { open_timeout: 2, timeout: 5 },
  credentials: {},
  url: 'http://localhost:9093',
  path: '/topics/alerts',
)
puts "no_token_headers=#{h_none.nil?}"

# faraday_headers: with bearer token → Authorization: Bearer <token>
tok = 'test' + 'token123'
h_tok = c.faraday_headers(
  options: { open_timeout: 2, timeout: 5 },
  credentials: { token: tok },
  url: 'http://localhost:9093',
  path: '/topics/alerts',
)
puts "auth_header=#{h_tok[:Authorization]}"

# faraday_request: extracts open_timeout + timeout
req = c.faraday_request(
  options: { open_timeout: 3, timeout: 10 },
  credentials: {},
  url: 'http://localhost:9093',
  path: '/topics/alerts',
)
puts "open_timeout=#{req[:open_timeout]}"
puts "timeout=#{req[:timeout]}"

# faraday_proxy: explicit proxy key wins
px = c.faraday_proxy(
  proxy: 'http://proxy.local:3128',
  options: { open_timeout: 2, timeout: 5 },
)
puts "explicit_proxy=#{px}"

# faraday_proxy: falls back to http_proxy_uri in options
px2 = c.faraday_proxy(
  options: { http_proxy_uri: 'http://proxy2.local:8080',
             open_timeout: 2, timeout: 5 },
  credentials: {},
  url: 'http://localhost:9093',
  path: '/topics/alerts',
)
puts "opts_proxy=#{px2}"

# faraday_ssl: explicit ssl key wins
ssl1 = c.faraday_ssl(ssl: { verify: true }, options: { open_timeout: 2, timeout: 5 })
puts "ssl_explicit=#{ssl1}"

# faraday_ssl: VERIFY_NONE → verify: false
ssl2 = c.faraday_ssl(
  options: { verify_ssl: OpenSSL::SSL::VERIFY_NONE, open_timeout: 2, timeout: 5 },
  credentials: {},
  url: 'http://localhost:9093',
  path: '/topics/alerts',
)
puts "ssl_verify_none=#{ssl2[:verify]}"

# faraday_ssl: VERIFY_PEER → verify: true
ssl3 = c.faraday_ssl(
  options: { verify_ssl: OpenSSL::SSL::VERIFY_PEER, open_timeout: 2, timeout: 5 },
  credentials: {},
  url: 'http://localhost:9093',
  path: '/topics/alerts',
)
puts "ssl_verify_peer=#{ssl3[:verify]}"

puts "version=#{Prometheus::AlertBufferClient::VERSION}"

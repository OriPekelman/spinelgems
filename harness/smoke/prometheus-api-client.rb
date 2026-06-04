# frozen_string_literal: true

# Stub faraday (not available standalone) before loading the gem.
# prometheus-api-client uses faraday only inside Client#initialize and
# Client#get; all helper/options methods are pure Ruby and exercise real logic.
original_require = method(:require)
define_method(:require) do |name|
  if name == 'faraday' || name == 'faraday/net_http'
    unless defined?(Faraday)
      module Faraday
        class Connection
          def adapter(*args); end
          def get(*args); raise 'no network'; end
        end
        def self.new(opts = {}, &block)
          c = Connection.new
          block.call(c) if block
          c
        end
      end
    end
    true
  else
    original_require.call(name)
  end
end

require 'prometheus/api_client/version'
require 'prometheus/api_client'

# 1. Version constant
puts Prometheus::ApiClient::VERSION

# 2. DEFAULT_ARGS shape
defs = Prometheus::ApiClient::Client::DEFAULT_ARGS
puts defs[:url]
puts defs[:path]
puts defs[:options][:open_timeout]
puts defs[:options][:timeout]

# 3. Client construction with custom URL+path
client = Prometheus::ApiClient::Client.new(url: 'http://prometheus.example.com:9090', path: '/api/v1/')

# 4. faraday_options: URL concatenation
opts = client.send(:faraday_options, {
  url: 'http://prometheus.example.com:9090',
  path: '/api/v1/',
  credentials: {},
  options: { open_timeout: 5, timeout: 15 },
})
puts opts[:url]
puts opts[:proxy].nil?
puts opts[:ssl].nil?

# 5. faraday_headers: Bearer token from credentials
opts_with_token = client.send(:faraday_options, {
  url: 'http://prometheus.example.com:9090',
  path: '/api/v1/',
  credentials: { token: 'my-secret-token' },
  options: { open_timeout: 5, timeout: 15 },
})
puts opts_with_token[:headers][:Authorization]

# 6. faraday_request: timeout extraction
req = client.send(:faraday_request, {
  options: { open_timeout: 3, timeout: 10 },
})
puts req[:open_timeout]
puts req[:timeout]

# 7. faraday_proxy: proxy from options hash
proxy = client.send(:faraday_proxy, { proxy: 'http://proxy.example.com:3128' })
puts proxy

# 8. faraday_proxy: nil when none set
proxy_none = client.send(:faraday_proxy, { options: {} })
puts proxy_none.nil?

# 9. faraday_headers: nil when no credentials
headers_none = client.send(:faraday_headers, { credentials: {} })
puts headers_none.nil?

# 10. RequestError is a StandardError subclass
err = Prometheus::ApiClient::Client::RequestError.new('query timeout')
puts err.message
puts err.is_a?(StandardError)
puts err.is_a?(Prometheus::ApiClient::Client::RequestError)

# 11. run_command wraps HTTP errors as RequestError
begin
  client.run_command('query', { query: 'up' })
rescue Prometheus::ApiClient::Client::RequestError => e
  puts "RequestError: #{e.message.include?('no network') || !e.message.empty?}"
end

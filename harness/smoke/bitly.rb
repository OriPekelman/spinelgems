# frozen_string_literal: true
# Smoke test for bitly-3.1.0
# Exercises pure-logic paths that don't require network/API token:
#   - Bitly::HTTP::Request (URI construction, params serialisation, body)
#   - Bitly::HTTP::Response (JSON parsing, status reader)
#   - Bitly::API::Bitlink::Utils.normalise_bitlink (URL normalisation)
#   - Bitly::Error class hierarchy

require 'bitly'

# 1. Bitlink URL normalisation — pure string logic
puts Bitly::API::Bitlink::Utils.normalise_bitlink(bitlink: "https://bit.ly/abc123")
puts Bitly::API::Bitlink::Utils.normalise_bitlink(bitlink: "http://bit.ly/xyz")
puts Bitly::API::Bitlink::Utils.normalise_bitlink(bitlink: "bit.ly/plain")

# 2. HTTP Request: GET with params becomes a query string
require 'uri'
uri = URI.parse("https://api-ssl.bitly.com/v4/bitlinks/bit.ly/abc")
req = Bitly::HTTP::Request.new(uri: uri, method: "GET", params: { "unit" => "day", "units" => 7 })
puts req.method
puts req.uri.query
puts req.body.nil?

# 3. HTTP Request: POST body is JSON
uri2 = URI.parse("https://api-ssl.bitly.com/v4/shorten")
req2 = Bitly::HTTP::Request.new(uri: uri2, method: "POST", params: { "long_url" => "https://example.com", "domain" => "bit.ly" })
puts req2.body

# 4. HTTP Response: JSON body is parsed to a hash
resp = Bitly::HTTP::Response.new(
  status: "200",
  body: '{"id":"bit.ly/abc","link":"https://bit.ly/abc","long_url":"https://example.com"}',
  headers: {}
)
puts resp.status
puts resp.body["id"]
puts resp.body["long_url"]

# 5. Bitly::Error is a StandardError
puts Bitly::Error.ancestors.include?(StandardError)

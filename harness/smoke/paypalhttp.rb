require 'paypalhttp'
require 'ostruct'

# 1. Environment: stores a base URL
env = PayPalHttp::Environment.new('https://api.sandbox.paypal.com')
puts env.base_url

env.base_url = 'https://api.paypal.com'
puts env.base_url

# 2. HttpError: captures status code, result, headers
err = PayPalHttp::HttpError.new(404, 'Not found', { 'content-type' => 'text/plain' })
puts err.status_code
puts err.result
puts err.headers['content-type']

# 3. UnsupportedEncodingError: wraps a message
begin
  raise PayPalHttp::UnsupportedEncodingError.new('bad encoding')
rescue PayPalHttp::UnsupportedEncodingError => e
  puts e.message
end

# 4. Encoder: supported_encodings listing
enc = PayPalHttp::Encoder.new
puts enc.supported_encodings.length

# 5. Encoder: serialize a JSON request
req = OpenStruct.new(
  headers: { 'content-type' => 'application/json' },
  body: { 'amount' => '10.00', 'currency' => 'USD' }
)
serialized = enc.serialize_request(req)
puts serialized.include?('amount')
puts serialized.include?('USD')

# 6. Encoder: deserialize a JSON response
json_body = '{"status":"CREATED","id":"ORDER-123"}'
result = enc.deserialize_response(json_body, { 'content-type' => 'application/json' })
puts result['status']
puts result['id']

# 7. Encoder: serialize a text/plain request
text_req = OpenStruct.new(
  headers: { 'content-type' => 'text/plain' },
  body: 'hello paypal'
)
puts enc.serialize_request(text_req)

# 8. Encoder: missing content-type raises UnsupportedEncodingError
begin
  bad_req = OpenStruct.new(headers: {}, body: 'data')
  enc.serialize_request(bad_req)
rescue PayPalHttp::UnsupportedEncodingError => e
  puts 'missing-ct-error'
end

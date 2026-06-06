require 'braintreehttp'
require 'ostruct'

# 1. Environment: base_url accessor
env = BraintreeHttp::Environment.new("https://api.sandbox.example.com")
puts env.base_url

# 2. Encoder: JSON round-trip
encoder = BraintreeHttp::Encoder.new

json_req = OpenStruct.new(
  headers: { 'Content-Type' => 'application/json' },
  body: { "amount" => "10.00", "currency" => "USD" }
)
serialized = encoder.serialize_request(json_req)
puts serialized

decoded = encoder.deserialize_response(serialized, { 'content-type' => 'application/json' })
puts decoded["amount"]
puts decoded["currency"]

# 3. Encoder: text round-trip
text_req = OpenStruct.new(
  headers: { 'Content-Type' => 'text/plain' },
  body: "hello braintreehttp"
)
text_out = encoder.serialize_request(text_req)
puts text_out
puts encoder.deserialize_response(text_out, { 'content-type' => 'text/plain' })

# 4. Encoder#supported_encodings returns array of regexps
encs = encoder.supported_encodings
puts encs.length

# 5. HttpClient#has_body
client = BraintreeHttp::HttpClient.new(env)
req_with_body = OpenStruct.new(body: "data")
req_no_body   = OpenStruct.new
puts client.has_body(req_with_body)
puts client.has_body(req_no_body)

# 6. UnsupportedEncodingError is raised for unknown content-type
begin
  bad_req = OpenStruct.new(
    headers: { 'Content-Type' => 'application/octet-stream' },
    body: "bytes"
  )
  encoder.serialize_request(bad_req)
rescue BraintreeHttp::UnsupportedEncodingError => e
  puts "UnsupportedEncodingError raised"
end

# 7. HttpError holds attributes
err = BraintreeHttp::HttpError.new(404, "not found", { "x-req-id" => ["abc"] })
puts err.status_code
puts err.result

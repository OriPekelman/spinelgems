require 'jsender'

# Exercise Jsender::Json — pure JSON response builders
puts Jsender::Json.error
puts Jsender::Json.error(message: "Not found")
puts Jsender::Json.failure
puts Jsender::Json.failure(message: "Validation failed", data: { 'field' => 'email' })
puts Jsender::Json.success
puts Jsender::Json.success(data: { 'id' => 42, 'name' => 'widget' })

# Exercise Jsender::Rack — returns [code, headers, body] triplets
code, headers, body = Jsender::Rack.success(data: { 'ok' => true })
puts code
puts headers['Content-Type']
puts body

code2, headers2, body2 = Jsender::Rack.error(code: 503, message: "Unavailable")
puts code2
puts headers2['Content-Type']
puts body2

code3, headers3, body3 = Jsender::Rack.failure(code: 422, data: { 'reason' => 'bad input' })
puts code3
puts body3

# body_as_array variant returns an Array wrapping the JSON string
code4, _h4, body4 = Jsender::Rack.success(data: { 'x' => 1 }, body_as_array: true)
puts code4
puts body4.class
puts body4.first

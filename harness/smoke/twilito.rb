# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'twilito'

# 1. Configuration: set attributes and read back via to_h
Twilito.configure do |c|
  c.account_sid = 'ACtest1234567890'
  c.auth_token  = 'token' + 'abc'   # built at runtime, no literal secret shape
  c.from        = '+15005550006'
  c.to          = '+15005550001'
  c.body        = 'Hello from Twilito smoke'
end

cfg = Twilito.configuration
puts cfg.account_sid
puts cfg.from
puts cfg.to
puts cfg.body

h = cfg.to_h
puts h[:account_sid]
puts h[:from]
puts h[:to]
puts h[:body]

# 2. Result: success factory
r_ok = Twilito::Result.success(response: nil, sid: 'SM123abc')
puts r_ok.success?
puts r_ok.sid
puts r_ok.errors.inspect

# 3. Result: failure factory
r_fail = Twilito::Result.failure(response: nil, errors: ['Bad request', 'Missing body'])
puts r_fail.success?
puts r_fail.errors.inspect

# 4. SendError: message + response preserved
err = Twilito::SendError.new('Error from Twilio API', :fake_response)
puts err.message
puts err.response.inspect

# 5. API: messages_uri builds the right path (no network — just URI construction)
uri = Twilito.messages_uri('ACtest1234567890')
puts uri.host
puts uri.path

# 6. API: twilio_form_data converts snake_case keys to CamelCase, strips auth
args = {
  to: '+15005550001',
  from: '+15005550006',
  messaging_service_sid: nil,
  body: 'Hello',
  account_sid: 'ACtest',
  auth_token: 'tok'
}
# twilio_form_data is private but accessible via send
form_data = Twilito.send(:twilio_form_data, args)
puts form_data.sort.map { |k, v| "#{k}=#{v}" }.join(', ')

# 7. ArgumentError raised for missing required keys
begin
  Twilito.reset_configuration!
  Twilito.send(:merge_configuration, { to: '+1', body: 'hi', account_sid: 'ACx', auth_token: 't' })
rescue Twilito::ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# 8. No error when messaging_service_sid is present instead of from
Twilito.reset_configuration!
merged = Twilito.send(:merge_configuration, {
  to: '+1', messaging_service_sid: 'MG123', body: 'hi', account_sid: 'ACx', auth_token: 't'
})
puts merged[:messaging_service_sid]
puts merged[:to]

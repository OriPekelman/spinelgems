# frozen_string_literal: true
require 'eztz'

# Test Eztz module configuration
Eztz.configure do |config|
  config.api_key = 'test' + '_key_' + '12345'
end
puts Eztz.api_key

# Test Client initialization stores the api_key
client = Eztz::Client.new(api_key: 'my' + '_api' + '_key')
puts client.api_key

# Test TimeZoneResponse with a simulated API response hash
response_data = {
  "dstOffset"    => 3600,
  "rawOffset"    => 36000,
  "status"       => "OK",
  "timeZoneId"   => "Australia/Sydney",
  "timeZoneName" => "Australian Eastern Daylight Time",
  "error_message" => nil
}
ts = 1_488_580_176
resp = Eztz::TimeZoneResponse.new(ts, response_data)

puts resp.status
puts resp.id
puts resp.name
puts resp.raw_offset
puts resp.dst_offset
puts resp.timestamp
puts resp.success?
puts resp.local_time.utc.strftime("%Y-%m-%dT%H:%M:%SZ")

# to_h returns expected keys
h = resp.to_h
puts h.keys.sort.map(&:to_s).join(",")

# TimeZoneResponse with non-OK status
bad_data = {
  "dstOffset"    => 0,
  "rawOffset"    => 0,
  "status"       => "REQUEST_DENIED",
  "timeZoneId"   => nil,
  "timeZoneName" => nil,
  "error_message" => "This IP is blocked"
}
bad_resp = Eztz::TimeZoneResponse.new(ts, bad_data)
puts bad_resp.success?
puts bad_resp.error_message

# ApiError
err = Eztz::ApiError.new('{"status":"OVER_QUERY_LIMIT"}')
puts err.message
puts err.to_s

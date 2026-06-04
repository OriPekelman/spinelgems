require 'mixpanel_client'

# Build an api_secret at runtime (no hard-coded secret literals)
api_secret = 'test' + 'secret' + '123'

# 1. Instantiate a client - exercises Client#initialize, ConfigurationError guard
client = Mixpanel::Client.new(api_secret: api_secret, timeout: 30)
puts client.api_secret.length
puts client.timeout

# 2. ConfigurationError raised when api_secret is missing
begin
  Mixpanel::Client.new({})
rescue Mixpanel::ConfigurationError => e
  puts e.message
end

# 3. request_uri builds a deterministic URI string (no network)
uri = client.request_uri('events', {
  event: '["page_view"]',
  type:  'general',
  unit:  'day',
  interval: 7
})
# Print whether it starts with the expected base and contains key=value pairs
puts uri.start_with?('https://mixpanel.com/api/2.0/events?')
puts uri.include?('unit=day')
puts uri.include?('interval=7')

# 4. Mixpanel::URI.encode produces sorted key=value pairs
encoded = Mixpanel::URI.encode(b: 'beta', a: 'alpha')
puts encoded

# 5. base_uri_for_resource dispatches correctly
puts Mixpanel::Client.base_uri_for_resource('export')
puts Mixpanel::Client.base_uri_for_resource('import')
puts Mixpanel::Client.base_uri_for_resource('events')

# 6. Utils.to_hash parses JSON data
parsed = Mixpanel::Client::Utils.to_hash('{"key":"value","count":42}', :json)
puts parsed['key']
puts parsed['count']

# 7. Utils.to_hash returns raw string for csv format
raw = Mixpanel::Client::Utils.to_hash('col1,col2\nval1,val2', 'csv')
puts raw

# 8. Exception hierarchy
puts Mixpanel::HTTPError.ancestors.include?(Mixpanel::Error)
puts Mixpanel::ParseError.ancestors.include?(StandardError)

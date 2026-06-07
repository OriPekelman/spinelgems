require 'etracking'

# Test Client initialization via block config
client = Etracking::Client.new do |config|
  config.api_key = 'test' + '_key_123'
  config.key_secret = 'test' + '_secret_456'
  config.language = 'EN'
end

puts client.api_key
puts client.key_secret
puts client.language

# Test initialization via options hash
client2 = Etracking::Client.new(api_key: 'hash' + '_key', key_secret: 'hash' + '_sec', language: 'TH')
puts client2.api_key
puts client2.key_secret
puts client2.language

# Test endpoint method
puts client.endpoint

# Test payload builder methods
p client.payload_tracking_number('TH1234567890')
p client.payload_with_courier_and_tracking_number('DHL', 'DHL987654')
p client.payload_with_courier_and_tracking_numbers('Kerry', ['K001', 'K002'])

# Test that api_key_required raises correctly when key is missing
begin
  client3 = Etracking::Client.new
  client3.send(:api_key_required)
  puts "no error raised"
rescue ArgumentError => e
  puts e.message
end

# Test that key_secret_required raises correctly
begin
  client4 = Etracking::Client.new(api_key: 'present')
  client4.send(:key_secret_required)
  puts "no error raised"
rescue ArgumentError => e
  puts e.message
end

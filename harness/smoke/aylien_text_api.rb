require 'aylien_text_api'

# 1. Configuration module: constants and defaults
puts AylienTextApi::Configuration::VALID_CONNECTION_KEYS.sort.inspect
puts AylienTextApi::Configuration::VALID_OPTIONS_KEYS.sort.inspect
puts AylienTextApi::Configuration::DEFAULT_METHOD.inspect
puts AylienTextApi::Configuration::DEFAULT_BASE_URI

# 2. Module-level reset + options hash
AylienTextApi.reset
opts = AylienTextApi.options
puts opts[:base_uri]
puts opts[:method].inspect
puts opts[:app_id].inspect
puts opts[:app_key].inspect

# 3. configure block sets values
AylienTextApi.configure do |c|
  c.app_id  = "test-app-id"
  c.app_key = "test-app-key"
end
puts AylienTextApi.app_id
puts AylienTextApi.app_key

# 4. Client initializes with merged config
client = AylienTextApi::Client.new(app_id: "client-id", app_key: "client-key")
puts client.app_id
puts client.app_key
puts client.base_uri
puts client.method.inspect

# 5. Error hierarchy
puts AylienTextApi::Error.superclass
puts AylienTextApi::Error::ClientError.superclass
puts AylienTextApi::Error::InvalidInput.superclass
puts AylienTextApi::Error::BadRequest.superclass
puts AylienTextApi::Error::Unauthorized.superclass
puts AylienTextApi::Error::ServerError.superclass

# 6. ERRORS map completeness
err_codes = AylienTextApi::Error::ERRORS.keys.sort
puts err_codes.inspect
puts AylienTextApi::Error::ERRORS[400]
puts AylienTextApi::Error::ERRORS[401]
puts AylienTextApi::Error::ERRORS[500]

# 7. InvalidInput raised for blank taxonomy
begin
  client.classify_by_taxonomy("some text", taxonomy: "")
rescue AylienTextApi::Error::InvalidInput => e
  puts "InvalidInput: #{e.message}"
end

# 8. InvalidInput raised for blank domain (ABSA)
begin
  client.aspect_based_sentiment("some text", domain: "")
rescue AylienTextApi::Error::InvalidInput => e
  puts "InvalidInput: #{e.message}"
end

# 9. ENDPOINTS hash keys
puts AylienTextApi::Configuration::ENDPOINTS.keys.sort.inspect

# 10. VERSION
puts AylienTextApi::VERSION

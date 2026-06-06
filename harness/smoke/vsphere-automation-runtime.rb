require 'vsphere-automation-runtime'

# --- 1. Configuration defaults ---
config = VSphereAutomation::Configuration.new
puts "scheme: #{config.scheme}"
puts "host: #{config.host}"
puts "base_path: #{config.base_path}"
puts "client_side_validation: #{config.client_side_validation}"
puts "verify_ssl: #{config.verify_ssl}"
puts "debugging: #{config.debugging}"

# --- 2. Configuration mutation and base_url ---
config.scheme = 'https://'       # setter strips ://
config.host   = 'https://vcenter.example.com/extra'  # setter strips scheme + path
config.base_path = '/api/v1'
puts "scheme after set: #{config.scheme}"
puts "host after set: #{config.host}"
puts "base_path after set: #{config.base_path}"
puts "base_url: #{config.base_url}"

# --- 3. API key with prefix ---
config.api_key['my-key'] = 'abc123'
config.api_key_prefix['my-key'] = 'Bearer'
puts "api_key_with_prefix: #{config.api_key_with_prefix('my-key')}"
puts "api_key_no_prefix: #{config.api_key_with_prefix('missing-key').inspect}"

# --- 4. Basic auth token ---
config.username = 'admin'
config.password = 'hunter2'
token = config.basic_auth_token
# Should start with "Basic " and be base64 of "admin:hunter2"
puts "basic_auth_token starts with Basic: #{token.start_with?('Basic ')}"
decoded = token.sub('Basic ', '').unpack1('m')
puts "decoded credentials: #{decoded}"

# --- 5. auth_settings structure ---
settings = config.auth_settings
puts "auth_settings keys: #{settings.keys.sort.join(', ')}"
puts "api_key type: #{settings['api_key'][:type]}"
puts "basic_auth type: #{settings['basic_auth'][:type]}"
puts "basic_auth in: #{settings['basic_auth'][:in]}"

# --- 6. ApiError construction ---
err1 = VSphereAutomation::ApiError.new("something went wrong")
puts "error message: #{err1.message}"
puts "error code nil: #{err1.code.nil?}"

err2 = VSphereAutomation::ApiError.new(code: 404, message: "Not Found")
puts "error2 message: #{err2.message}"
puts "error2 code: #{err2.code}"

err3 = VSphereAutomation::ApiError.new(code: 500, response_body: '{"error":"internal"}')
puts "error3 code: #{err3.code}"
puts "error3 response_body: #{err3.response_body}"

# --- 7. ApiClient select_header methods ---
client = VSphereAutomation::ApiClient.new(config)
puts "accept json: #{client.select_header_accept(['application/json', 'text/plain'])}"
puts "accept fallback: #{client.select_header_accept(['text/html', 'text/plain'])}"
puts "accept nil: #{client.select_header_accept(nil)}"
puts "content_type json: #{client.select_header_content_type(['application/json', 'text/plain'])}"
puts "content_type fallback: #{client.select_header_content_type(['text/html'])}"

# --- 8. object_to_http_body ---
puts "body string: #{client.object_to_http_body('hello')}"
puts "body array: #{client.object_to_http_body(['a', 'b'])}"

# --- 9. Version constant ---
puts "version: #{VSphereAutomation::Runtime::VERSION}"

# --- 10. VSphereAutomation.configure block form ---
VSphereAutomation.configure do |c|
  c.username = 'block_user'
  c.password = 'block_pass'
end
puts "configure block username: #{VSphereAutomation::Configuration.default.username}"

# --- 11. Configuration.default singleton ---
cfg_a = VSphereAutomation::Configuration.default
cfg_b = VSphereAutomation::Configuration.default
puts "default singleton: #{cfg_a.equal?(cfg_b)}"

puts "DONE"

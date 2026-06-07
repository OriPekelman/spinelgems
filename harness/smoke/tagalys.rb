require 'tagalys'

# Test 1: Configuration class - default values
cfg = Tagalys::Configuration.new
puts cfg.client_code.inspect   # nil
puts cfg.store_id.inspect      # nil
puts cfg.api_key.inspect       # nil

# Test 2: configure block sets values
Tagalys.configure do |c|
  c.client_code = "demo_client"
  c.store_id    = "store_42"
  c.api_key     = "key_" + "abc123"
end

puts Tagalys.configuration.client_code  # demo_client
puts Tagalys.configuration.store_id     # store_42
puts Tagalys.configuration.api_key      # key_abc123

# Test 3: identification hash structure
id = Tagalys.identification
puts id[:client_code]   # demo_client
puts id[:store_id]      # store_42
puts id[:api_key]       # key_abc123
puts id.keys.sort.inspect  # [:api_key, :client_code, :store_id]

# Test 4: search with nil query AND nil filter returns error hash (no network call)
result = Tagalys.search(nil, nil)
puts result[:status]    # Either query or filter should be present

# Test 5: reset clears configuration
Tagalys.reset
puts Tagalys.configuration.client_code.inspect  # nil

# Test 6: configuration attr_accessor mutation
Tagalys.configuration.client_code = "new_client"
Tagalys.configuration.store_id    = "s99"
puts Tagalys.configuration.client_code  # new_client
puts Tagalys.configuration.store_id     # s99

config = QuadrigaCX::Configuration.new
config.client_id = "my_client"
config.api_key = "my_key"
config.api_secret = "my_secret"
puts config.client_id
puts config.api_key
puts config.api_secret
puts config.client_id.class
puts QuadrigaCX::Configuration.new.client_id.nil?

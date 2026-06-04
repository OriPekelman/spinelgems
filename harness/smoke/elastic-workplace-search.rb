require 'elastic-workplace-search'

# --- Configuration module ---
# Default endpoint ends with '/'
puts Elastic::WorkplaceSearch::Configuration::DEFAULT_ENDPOINT
# => http://localhost:3002/api/ws/v1/

# reset returns self with nil access_token and default endpoint
Elastic::WorkplaceSearch.reset
puts Elastic::WorkplaceSearch.access_token.inspect
# => nil
puts Elastic::WorkplaceSearch.endpoint
# => http://localhost:3002/api/ws/v1/

# configure block sets values
Elastic::WorkplaceSearch.configure do |c|
  c.access_token = 'tok-test-1234'
  c.endpoint = 'https://my-server.example.com/api/ws/v1'   # no trailing slash
  c.user_agent = 'MyApp/1.0'
end
puts Elastic::WorkplaceSearch.access_token
# => tok-test-1234
# endpoint setter ensures trailing slash
puts Elastic::WorkplaceSearch.endpoint
# => https://my-server.example.com/api/ws/v1/
puts Elastic::WorkplaceSearch.user_agent
# => MyApp/1.0

# options returns a Hash with all keys
opts = Elastic::WorkplaceSearch.options
puts opts.keys.sort.inspect
# => [:access_token, :endpoint, :user_agent]
puts opts[:access_token]
# => tok-test-1234

# --- Utils.stringify_keys ---
h = Elastic::WorkplaceSearch::Utils.stringify_keys(id: 42, title: 'hello', count: 3)
puts h.class
# => Hash
puts h.keys.sort.inspect
# => ["count", "id", "title"]
puts h['title']
# => hello
puts h['id']
# => 42

# --- Client instantiation and accessors ---
client = Elastic::WorkplaceSearch::Client.new(
  access_token: 'bearer-xyz',
  open_timeout: 30,
  overall_timeout: 60,
  proxy: 'http://proxy.example.com:8080'
)
puts client.access_token
# => bearer-xyz
puts client.open_timeout
# => 30
puts client.overall_timeout
# => 60.0
puts client.proxy
# => http://proxy.example.com:8080

# Client without explicit token falls back to module-level token
client2 = Elastic::WorkplaceSearch::Client.new
Elastic::WorkplaceSearch.reset
Elastic::WorkplaceSearch.access_token = 'fallback-token'
puts client2.access_token
# => fallback-token

# --- Exception hierarchy ---
puts Elastic::WorkplaceSearch::ClientException.ancestors.include?(StandardError)
# => true
[
  Elastic::WorkplaceSearch::NonExistentRecord,
  Elastic::WorkplaceSearch::InvalidCredentials,
  Elastic::WorkplaceSearch::BadRequest,
  Elastic::WorkplaceSearch::Forbidden,
  Elastic::WorkplaceSearch::UnexpectedHTTPException,
  Elastic::WorkplaceSearch::InvalidDocument
].each do |klass|
  puts "#{klass} < ClientException: #{klass.ancestors.include?(Elastic::WorkplaceSearch::ClientException)}"
end

# --- VERSION constant ---
puts Elastic::WorkplaceSearch::VERSION
# => 0.4.1

# --- CLIENT_NAME and CLIENT_VERSION constants ---
puts Elastic::WorkplaceSearch::CLIENT_NAME
# => elastic-workplace-search-ruby
puts Elastic::WorkplaceSearch::CLIENT_VERSION
# => 0.4.1

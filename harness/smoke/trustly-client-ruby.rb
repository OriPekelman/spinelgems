require 'trustly'

# trustly-client-ruby uses ActiveSupport's Object#try — define a minimal shim
class Object
  def try(method_name, *args, &block)
    send(method_name, *args, &block)
  rescue NoMethodError
    nil
  end
end

class NilClass
  def try(*args)
    nil
  end
end

# We can't instantiate Trustly::Api directly (calls load_trustly_publickey),
# so create a minimal subclass that skips loading
class TestApi < Trustly::Api
  def initialize; end
  def url_path(request=nil); '/api/1'; end
  def handle_response(request, httpcall); end
  def insert_credentials(request); end
end

api = TestApi.new

# serialize_data: pure hash/array/scalar serialization (sorted keys)
puts api.serialize_data("hello")
puts api.serialize_data(42)
puts api.serialize_data({"z" => "last", "a" => "first", "m" => "middle"})
puts api.serialize_data(["alpha", "beta", "gamma"])
puts api.serialize_data({"key" => ["x", "y"]})
puts api.serialize_data({}).inspect
puts api.serialize_data([]).inspect

# base_url construction
api2 = TestApi.new
api2.api_host    = 'test.trustly.com'
api2.api_port    = 443
api2.api_is_https = true
puts api2.send(:base_url)

api3 = TestApi.new
api3.api_host    = 'test.trustly.com'
api3.api_port    = 8080
api3.api_is_https = false
puts api3.send(:base_url)

# Trustly::Data — payload management
data = Trustly::Data.new
data.set('version', '1.1')
data.set('method', 'Deposit')
puts data.get('version')
puts data.get('method')
puts data.get('nonexistent').inspect

# Exercise Trustly::Data::JSONRPCRequest with data+attributes
req = Trustly::Data::JSONRPCRequest.new(
  'Deposit',
  {"NotificationURL" => "https://example.com", "EndUserID" => "user1"},
  {"Locale" => "en_US", "Currency" => "EUR"}
)
puts req.get_method
puts req.get_data('NotificationURL')
puts req.get_attribute('Locale')
puts req.get('version')

# data-only request
req2 = Trustly::Data::JSONRPCRequest.new('Refund', {"OrderID" => "9999", "Amount" => "50.00", "Currency" => "EUR"}, nil)
req2.set_uuid('aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee')
puts req2.get_uuid
puts req2.get_data('OrderID')
puts req2.get_method

# Version constant
puts Trustly::VERSION

# Exception hierarchy
puts Trustly::Exception::DataError.ancestors.include?(Exception)
puts Trustly::Exception::SignatureError.superclass

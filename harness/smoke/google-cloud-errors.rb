# smoke: google-cloud-errors — exercises error class hierarchy, gRPC/HTTP mappings,
# from_error factory, and error code accessors.
require 'google-cloud-errors'

# 1. Basic error instantiation and message
err = Google::Cloud::Error.new("base error message")
puts err.message
puts err.class

# 2. Subclass error codes (gRPC codes)
[
  Google::Cloud::CanceledError,
  Google::Cloud::NotFoundError,
  Google::Cloud::PermissionDeniedError,
  Google::Cloud::UnauthenticatedError,
  Google::Cloud::InternalError,
].each do |klass|
  e = klass.new("test")
  puts "#{klass.name.split('::').last}: code=#{e.code}"
end

# 3. grpc_error_class_for — map gRPC codes to subclasses
[0, 1, 5, 7, 16].each do |grpc_code|
  klass = Google::Cloud::Error.grpc_error_class_for(grpc_code)
  puts "grpc(#{grpc_code}) => #{klass.name.split('::').last}"
end

# 4. gapi_error_class_for — map HTTP status codes to subclasses
[400, 401, 403, 404, 500, 503, 999].each do |http_code|
  klass = Google::Cloud::Error.gapi_error_class_for(http_code)
  puts "http(#{http_code}) => #{klass.name.split('::').last}"
end

# 5. from_error with a mock gRPC-like error (responds to :code)
mock_grpc = Struct.new(:message, :code).new("grpc not found", 5)
derived = Google::Cloud::Error.from_error(mock_grpc)
puts derived.class.name.split('::').last
puts derived.message

# 6. from_error with a mock HTTP-like error (responds to :status_code)
mock_http = Struct.new(:message, :status_code).new("http unauth", 401)
derived2 = Google::Cloud::Error.from_error(mock_http)
puts derived2.class.name.split('::').last
puts derived2.message

# 7. nil cause — status_code/body/code/details return nil
plain = Google::Cloud::Error.new("plain")
puts plain.status_code.inspect
puts plain.code.inspect
puts plain.details.inspect

# 8. Inheritance check
puts Google::Cloud::NotFoundError.ancestors.include?(Google::Cloud::Error)
puts Google::Cloud::Error.ancestors.include?(StandardError)

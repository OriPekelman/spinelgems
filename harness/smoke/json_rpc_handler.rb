# Constants defined in the main file (not from version.rb)
puts JsonRpcHandler::Version::V1_0
puts JsonRpcHandler::Version::V2_0
puts JsonRpcHandler::ErrorCode::InvalidRequest
puts JsonRpcHandler::ErrorCode::MethodNotFound
puts JsonRpcHandler::ErrorCode::InvalidParams
puts JsonRpcHandler::ErrorCode::InternalError
puts JsonRpcHandler::ErrorCode::ParseError

# Pure validation helpers (no start_with? / no external deps)
puts JsonRpcHandler.valid_version?('2.0')
puts JsonRpcHandler.valid_version?('1.0')
puts JsonRpcHandler.valid_id?(42)
puts JsonRpcHandler.valid_id?('abc')
puts JsonRpcHandler.valid_id?(nil)
puts JsonRpcHandler.valid_id?([])
puts JsonRpcHandler.valid_params?(nil)
puts JsonRpcHandler.valid_params?([1,2])
puts JsonRpcHandler.valid_params?({a: 1})
puts JsonRpcHandler.valid_params?('bad')

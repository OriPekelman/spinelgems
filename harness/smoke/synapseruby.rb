require_relative "lib/synapse_api/version"
require_relative "lib/synapse_api/error"

puts Synapse::VERSION
puts Synapse::Error.superclass
puts Synapse::Error::ClientError.superclass
puts Synapse::Error::BadRequest.superclass
puts Synapse::Error::ServerError.superclass
puts Synapse::Error::InternalServerError.superclass
puts Synapse::Error::ERRORS.keys.sort.inspect

require_relative "lib/stream/version"
require_relative "lib/stream/errors"

puts Stream::VERSION
puts Stream::Error.superclass.name
puts Stream::StreamApiResponseException.superclass.name
puts Stream::StreamApiResponseApiKeyException.superclass.name
puts Stream::StreamInputData.superclass.name
puts Stream::StreamApiResponseRateLimitReached.superclass.name

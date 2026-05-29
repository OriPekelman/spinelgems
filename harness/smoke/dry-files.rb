# dry-files smoke: constants and error class hierarchy (no filesystem, no external deps)
puts Dry::Files::VERSION
puts Dry::Files::Error.superclass
puts Dry::Files::IOError.superclass
puts Dry::Files::MissingTargetError.superclass

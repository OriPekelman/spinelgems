# frozen_string_literal: true

require 'null_logger'

logger = NullLogger.new

# All log-level predicate methods should return false
puts logger.debug?
puts logger.info?
puts logger.warn?
puts logger.error?
puts logger.fatal?

# All logging methods should return nil (printed as empty line via p, or "nil" via puts nil.inspect)
puts logger.debug("some message").inspect
puts logger.info("some info").inspect
puts logger.warn("some warning").inspect
puts logger.error("some error").inspect
puts logger.fatal("some fatal").inspect
puts logger.unknown("some unknown").inspect

# Accepts multiple args, all swallowed
puts logger.debug("a", "b", "c").inspect

# Accepts a block-like lambda (common real usage pattern)
result = logger.info -> { "computed expensive message" }
puts result.inspect

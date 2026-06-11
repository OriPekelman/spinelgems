# Smoke test for inform gem - tests constants and log level API
puts Inform::VERSION
puts Inform::DEFAULT_LOG_LEVEL.inspect
puts Inform::LOG_LEVELS.inspect
puts Inform.level.inspect
Inform.level = :error
puts Inform.level.inspect
Inform.level = :debug
puts Inform.level.inspect
puts Inform::CLEAR.inspect
puts Inform::GREEN.inspect

require_relative "lib/lumberjack"

# SEQUENCE_MAX is a pure integer constant (2**32 - 1)
puts Lumberjack::SEQUENCE_MAX
puts Lumberjack::SEQUENCE_MAX.class

# The module itself is accessible
puts Lumberjack.respond_to?(:json)
puts Lumberjack.respond_to?(:json=)

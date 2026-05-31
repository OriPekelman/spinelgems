require_relative "lib/rugged_adapter/version"
puts Gollum::Lib::Git::VERSION
puts Gollum::Lib::Git::VERSION.class
parts = Gollum::Lib::Git::VERSION.split(".")
puts parts.length
puts parts.first

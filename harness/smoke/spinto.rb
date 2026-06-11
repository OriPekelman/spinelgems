puts Spinto::VERSION
puts Spinto::VERSION.class
puts Spinto.is_a?(Module)
puts Spinto::PLUGINS_PATH.end_with?('_plugins')
puts Spinto.respond_to?(:name)
puts Spinto.name

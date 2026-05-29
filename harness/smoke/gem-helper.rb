puts GemHelper::Loader.class
puts GemHelper::Loader.respond_to?(:config)
puts GemHelper::Loader.respond_to?(:load)
puts GemHelper::Loader.respond_to?(:configure)
puts GemHelper::RailsShim.class
puts GemHelper::RailsShim.respond_to?(:config)
puts GemHelper::RailsShim.respond_to?(:load)

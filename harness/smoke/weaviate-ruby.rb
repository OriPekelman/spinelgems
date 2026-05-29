require_relative "lib/weaviate"
puts Weaviate::VERSION
puts Weaviate::VERSION.class
puts Weaviate.is_a?(Module)

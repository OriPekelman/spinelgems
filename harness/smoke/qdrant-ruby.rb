require_relative "lib/qdrant"
puts Qdrant::VERSION
puts Qdrant::VERSION.class
puts Qdrant::VERSION.split(".").length
puts Qdrant::VERSION.start_with?("0.")
puts Qdrant.name

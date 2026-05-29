require_relative "lib/cohere"
puts Cohere::VERSION
puts Cohere::VERSION.class
puts Cohere::Error.ancestors.include?(StandardError)
puts Cohere::Error.new("test msg").message
puts Cohere.name

require_relative "lib/aplus"

puts Aplus::VERSION
puts Aplus::Error.superclass
puts Aplus::Error.new("test").message
puts Aplus::Error.ancestors.include?(StandardError)

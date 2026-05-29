require_relative "lib/tagrity/version"

puts Tagrity::VERSION
puts Tagrity::VERSION.class
puts Tagrity::VERSION.split('.').length
puts Tagrity::VERSION.start_with?("0.")

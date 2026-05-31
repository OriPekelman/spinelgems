require_relative "lib/twiglet/version"

puts Twiglet::VERSION
puts Twiglet::VERSION.class
puts Twiglet::VERSION.split(".").length
puts Twiglet::VERSION.start_with?("3")

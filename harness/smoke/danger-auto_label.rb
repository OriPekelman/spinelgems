require_relative "lib/auto_label/gem_version"

puts AutoLabel::VERSION
puts AutoLabel::VERSION.class
puts AutoLabel::VERSION.split(".").length
puts AutoLabel::VERSION.start_with?("1")

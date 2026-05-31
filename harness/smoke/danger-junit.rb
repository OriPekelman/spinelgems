require_relative "lib/junit/gem_version"

puts Junit::VERSION
puts Junit::VERSION.class
puts Junit::VERSION.frozen?
puts Junit::VERSION.split(".").length
puts Junit::VERSION.split(".").map(&:to_i).first >= 1

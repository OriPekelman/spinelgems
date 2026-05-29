require_relative "lib/slather/gem_version"

puts Slather::VERSION
puts Slather::VERSION.class
puts Slather::VERSION.frozen?
puts Slather::VERSION.split('.').length
puts Slather::VERSION.split('.').map(&:to_i).all? { |n| n >= 0 }

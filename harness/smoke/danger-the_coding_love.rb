require_relative "lib/the_coding_love/gem_version"

puts TheCodingLove::VERSION
puts TheCodingLove::VERSION.class
puts TheCodingLove::VERSION.split('.').length
puts TheCodingLove::VERSION.split('.').map(&:to_i).all? { |n| n >= 0 }

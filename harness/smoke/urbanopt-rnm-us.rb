require_relative "lib/urbanopt/rnm/version"

puts URBANopt::RNM::VERSION
puts URBANopt::RNM::VERSION.class
puts URBANopt::RNM::VERSION.frozen?
parts = URBANopt::RNM::VERSION.split(".")
puts parts.length
puts parts.first.to_i >= 1

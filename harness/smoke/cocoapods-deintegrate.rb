require_relative "lib/cocoapods/deintegrate/gem_version"

puts CocoapodsDeintegrate::VERSION
puts CocoapodsDeintegrate::VERSION.class
puts CocoapodsDeintegrate::VERSION.frozen?
puts CocoapodsDeintegrate::VERSION.split('.').length
puts CocoapodsDeintegrate::VERSION =~ /^\d+\.\d+\.\d+$/ ? "valid-semver" : "invalid"

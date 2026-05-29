require_relative "lib/yamlint/gem_version"

puts Yamlint::VERSION
puts Yamlint::VERSION.class
puts Yamlint::VERSION.frozen?
puts Yamlint::VERSION.split(".").length

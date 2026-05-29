require_relative "lib/shroud/gem_version"
puts Shroud::VERSION
puts Shroud::VERSION.class
puts Shroud::VERSION.frozen?
puts Shroud::VERSION.split('.').length
puts Shroud::VERSION == "2.0.0"

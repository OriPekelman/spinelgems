require_relative "lib/kotlin_detekt/gem_version"

puts KotlinDetekt::VERSION
puts KotlinDetekt::VERSION.class
puts KotlinDetekt::VERSION.frozen?
puts KotlinDetekt::VERSION.split(".").length
puts KotlinDetekt::VERSION.start_with?("0")

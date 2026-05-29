require_relative "lib/danger_pronto/gem_version"

puts Pronto::VERSION
puts Pronto::VERSION.class
puts Pronto::VERSION.frozen?
puts Pronto::VERSION.split(".").length
puts Pronto::VERSION.start_with?("0")

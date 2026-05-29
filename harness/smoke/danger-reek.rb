require_relative "lib/reek/gem_version"
puts Reek::VERSION
puts Reek::VERSION.class
puts Reek::VERSION.split(".").length
puts Reek::VERSION.start_with?("0")

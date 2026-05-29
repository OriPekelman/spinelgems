require_relative "lib/knife-cleanup/version"
puts Knife::Cleanup::VERSION
puts Knife::Cleanup::VERSION.class
puts Knife::Cleanup::VERSION.split(".").length
puts Knife::Cleanup::VERSION.start_with?("0")

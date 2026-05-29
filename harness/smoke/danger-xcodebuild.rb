require_relative "lib/xcodebuild/gem_version"

puts Xcodebuild::VERSION
puts Xcodebuild::VERSION.frozen?
puts Xcodebuild::VERSION.split(".").length
puts Xcodebuild::VERSION.start_with?("0")

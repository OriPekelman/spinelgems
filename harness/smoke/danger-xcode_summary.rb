require_relative "lib/xcode_summary/gem_version"

puts XcodeSummary::VERSION
puts XcodeSummary::VERSION.split('.').map(&:to_i).inspect
puts XcodeSummary::VERSION.length > 0

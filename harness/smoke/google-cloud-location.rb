require_relative "lib/google/cloud/location/version"

puts Google::Cloud::Location::VERSION
puts Google::Cloud::Location::VERSION.class
puts Google::Cloud::Location::VERSION.split(".").length
puts Google::Cloud::Location::VERSION.start_with?("1.")

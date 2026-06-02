require_relative "lib/google/cloud/compute/v1/version"

puts Google::Cloud::Compute::V1::VERSION
puts Google::Cloud::Compute::V1::VERSION.class
puts Google::Cloud::Compute::V1::VERSION.split(".").length
puts Google::Cloud::Compute::V1::VERSION.start_with?("3")

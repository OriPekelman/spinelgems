require_relative "lib/google/cloud/spanner/v1/version"

puts Google::Cloud::Spanner::V1::VERSION
puts Google::Cloud::Spanner::V1::VERSION.split(".").length
puts Google::Cloud::Spanner::V1::VERSION.start_with?("1.")

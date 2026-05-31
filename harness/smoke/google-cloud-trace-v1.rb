require_relative "lib/google/cloud/trace/v1/version"

puts Google::Cloud::Trace::V1::VERSION
puts Google::Cloud::Trace::V1::VERSION.class
puts Google::Cloud::Trace::V1::VERSION.split(".").length
puts Google::Cloud::Trace::V1::VERSION.start_with?("1.")

require_relative "lib/google/iam/v1/version"

puts Google::Iam::V1::VERSION
puts Google::Iam::V1::VERSION.split(".").map(&:to_i).inspect
puts Google::Iam::V1::VERSION.start_with?("1")
puts Google::Iam::V1::VERSION.length > 0
puts Google::Iam.name
puts Google::Iam::V1.name

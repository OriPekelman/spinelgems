require_relative "lib/google/cloud/data_catalog/v1/version"

puts Google::Cloud::DataCatalog::V1::VERSION
puts Google::Cloud::DataCatalog::V1::VERSION.class
puts Google::Cloud::DataCatalog::V1::VERSION.split(".").length
puts Google::Cloud::DataCatalog::V1::VERSION.start_with?("2")

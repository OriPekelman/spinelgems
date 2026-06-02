require_relative "lib/google/cloud/storage_transfer/v1/version"

puts Google::Cloud::StorageTransfer::V1::VERSION
puts Google::Cloud::StorageTransfer::V1::VERSION.class
puts Google::Cloud::StorageTransfer::V1::VERSION.split(".").length
puts Google::Cloud::StorageTransfer::V1::VERSION.start_with?("1.")

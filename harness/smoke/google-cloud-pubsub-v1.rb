# google-cloud-pubsub-v1 smoke
# Main entry file is a no-op; load version via require_relative (harness runs from gem root)
require_relative "lib/google/cloud/pubsub/v1/version"

puts Google::Cloud::PubSub::V1::VERSION
puts Google::Cloud::PubSub::V1::VERSION.class
puts Google::Cloud::PubSub::V1::VERSION.split(".").length
puts Google::Cloud::PubSub::V1::VERSION.start_with?("1.")

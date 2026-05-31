require_relative "lib/google/cloud/dialogflow/v2/version"

puts Google::Cloud::Dialogflow::V2::VERSION
puts Google::Cloud::Dialogflow::V2::VERSION.class
puts Google::Cloud::Dialogflow::V2::VERSION.split(".").length
puts Google::Cloud::Dialogflow::V2::VERSION.start_with?("1.")

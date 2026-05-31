# frozen_string_literal: true
# Smoke: google-cloud-vision-v1
# The gem entrypoint (lib/google-cloud-vision-v1.rb) is intentionally empty.
# Load pure-Ruby sub-files via require_relative from the gem root.

require_relative "lib/google/cloud/vision/v1/version"

puts Google::Cloud::Vision::V1::VERSION
puts Google::Cloud::Vision::V1::VERSION.class
puts Google::Cloud::Vision::V1::VERSION.split(".").length

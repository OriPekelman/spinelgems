# google-cloud-translate-v3 smoke
# The entrypoint is empty; load version directly (relative to gem root).
require_relative "lib/google/cloud/translate/v3/version"

puts Google::Cloud::Translate::V3::VERSION
puts Google::Cloud::Translate::V3::VERSION.class
puts Google::Cloud::Translate::V3::VERSION.frozen?
puts Google::Cloud::Translate::V3::VERSION.split(".").length

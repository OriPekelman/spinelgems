# frozen_string_literal: true
# Smoke: google-cloud-workflows-v1
# Exercises the self-contained Paths module (no network, no external deps)
# and the VERSION constant. Avoids gapic/common/googleauth which require
# live service connections.

require "google/cloud/workflows/v1/version"
require "google/cloud/workflows/v1/workflows/paths"

puts Google::Cloud::Workflows::V1::VERSION

include Google::Cloud::Workflows::V1::Workflows::Paths

# workflow_path
puts workflow_path(project: "my-project", location: "us-central1", workflow: "my-workflow")

# location_path
puts location_path(project: "acme-corp", location: "europe-west1")

# crypto_key_path
puts crypto_key_path(project: "secure-proj", location: "us-east4",
                     key_ring: "prod-ring", crypto_key: "signing-key")

# crypto_key_version_path
puts crypto_key_version_path(project: "secure-proj", location: "us-east4",
                              key_ring: "prod-ring", crypto_key: "signing-key",
                              crypto_key_version: "3")

# Error guard: slash in project raises ArgumentError
begin
  workflow_path(project: "bad/project", location: "us-central1", workflow: "wf")
  puts "ERROR: expected ArgumentError not raised"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# location_path only checks project, location may contain slashes — verify
result = location_path(project: "ok-project", location: "us/central1")
puts result

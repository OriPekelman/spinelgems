# frozen_string_literal: true
# Smoke test for google-cloud-speech-v1p1beta1
# Exercises the self-contained path-helper modules (no network, no gapic deps).
# These modules are real public API: users call e.g. client.phrase_set_path(...)

require "google/cloud/speech/v1p1beta1/version"
require "google/cloud/speech/v1p1beta1/speech/paths"
require "google/cloud/speech/v1p1beta1/adaptation/paths"

# VERSION constant
puts Google::Cloud::Speech::V1p1beta1::VERSION

# Speech::Paths helpers (extend self, so callable directly on the module)
puts Google::Cloud::Speech::V1p1beta1::Speech::Paths.crypto_key_path(
  project: "my-project",
  location: "us-central1",
  key_ring: "my-ring",
  crypto_key: "my-key"
)

puts Google::Cloud::Speech::V1p1beta1::Speech::Paths.crypto_key_version_path(
  project: "my-project",
  location: "us-central1",
  key_ring: "my-ring",
  crypto_key: "my-key",
  crypto_key_version: "1"
)

puts Google::Cloud::Speech::V1p1beta1::Speech::Paths.phrase_set_path(
  project: "my-project",
  location: "global",
  phrase_set: "greetings"
)

puts Google::Cloud::Speech::V1p1beta1::Speech::Paths.custom_class_path(
  project: "my-project",
  location: "us-east1",
  custom_class: "numerals"
)

# Adaptation::Paths helpers (same shape, separate module)
puts Google::Cloud::Speech::V1p1beta1::Adaptation::Paths.phrase_set_path(
  project: "proj-abc",
  location: "europe-west1",
  phrase_set: "farewell"
)

puts Google::Cloud::Speech::V1p1beta1::Adaptation::Paths.location_path(
  project: "proj-abc",
  location: "asia-east1"
)

# Validate argument guarding (slash in project must raise)
begin
  Google::Cloud::Speech::V1p1beta1::Speech::Paths.phrase_set_path(
    project: "bad/project",
    location: "us",
    phrase_set: "x"
  )
  puts "ERROR: expected ArgumentError not raised"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

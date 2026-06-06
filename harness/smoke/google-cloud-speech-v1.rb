# frozen_string_literal: true
# Smoke: google-cloud-speech-v1
# Exercises path-helper methods from both Adaptation and Speech modules.
# These modules use `extend self` and pure string interpolation — no network,
# no gRPC, no gapic dependencies.

require "google/cloud/speech/v1/adaptation/paths"
require "google/cloud/speech/v1/speech/paths"
require "google/cloud/speech/v1/version"

puts Google::Cloud::Speech::V1::VERSION

# --- Adaptation::Paths ---
puts Google::Cloud::Speech::V1::Adaptation::Paths.custom_class_path(
  project: "my-project",
  location: "us-central1",
  custom_class: "my-custom-class"
)

puts Google::Cloud::Speech::V1::Adaptation::Paths.location_path(
  project: "my-project",
  location: "us-east1"
)

puts Google::Cloud::Speech::V1::Adaptation::Paths.phrase_set_path(
  project: "my-project",
  location: "us-central1",
  phrase_set: "my-phrase-set"
)

# Slash-in-project raises ArgumentError
begin
  Google::Cloud::Speech::V1::Adaptation::Paths.custom_class_path(
    project: "bad/project",
    location: "us-central1",
    custom_class: "x"
  )
  puts "no error raised"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# Slash-in-location raises ArgumentError
begin
  Google::Cloud::Speech::V1::Adaptation::Paths.phrase_set_path(
    project: "my-project",
    location: "bad/location",
    phrase_set: "ps"
  )
  puts "no error raised"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# --- Speech::Paths ---
puts Google::Cloud::Speech::V1::Speech::Paths.custom_class_path(
  project: "speech-proj",
  location: "europe-west1",
  custom_class: "en-model"
)

puts Google::Cloud::Speech::V1::Speech::Paths.phrase_set_path(
  project: "speech-proj",
  location: "europe-west1",
  phrase_set: "en-phrases"
)

# Slash-in-project raises for Speech::Paths too
begin
  Google::Cloud::Speech::V1::Speech::Paths.phrase_set_path(
    project: "bad/proj",
    location: "us-central1",
    phrase_set: "ps"
  )
  puts "no error raised"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

puts "done"

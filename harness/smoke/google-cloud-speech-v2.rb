# frozen_string_literal: true
# Smoke: google-cloud-speech-v2 — Paths module path helpers (pure Ruby, no network)
require "google/cloud/speech/v2/speech/paths"

paths = Google::Cloud::Speech::V2::Speech::Paths

# recognizer_path
r = paths.recognizer_path(project: "my-proj", location: "us-central1", recognizer: "my-recognizer")
puts r

# config_path
c = paths.config_path(project: "my-proj", location: "global")
puts c

# custom_class_path
cc = paths.custom_class_path(project: "my-proj", location: "us-east1", custom_class: "tech-terms")
puts cc

# phrase_set_path
ps = paths.phrase_set_path(project: "my-proj", location: "europe-west1", phrase_set: "medical")
puts ps

# crypto_key_path
ck = paths.crypto_key_path(project: "my-proj", location: "us-central1", key_ring: "my-ring", crypto_key: "my-key")
puts ck

# location_path
lp = paths.location_path(project: "my-proj", location: "us-central1")
puts lp

# Verify validation: project containing "/" raises ArgumentError
begin
  paths.recognizer_path(project: "bad/proj", location: "us", recognizer: "r")
  puts "NO_ERROR"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# Verify validation: location containing "/" raises ArgumentError for recognizer_path
begin
  paths.recognizer_path(project: "proj", location: "bad/loc", recognizer: "r")
  puts "NO_ERROR"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

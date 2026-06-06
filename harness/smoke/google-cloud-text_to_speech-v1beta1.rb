# frozen_string_literal: true
# Smoke: google-cloud-text_to_speech-v1beta1
# Exercises: VERSION constant, Paths#model_path (both services), error handling on invalid input.
# No network, no gRPC, no external gems beyond the gem itself.

require "google/cloud/text_to_speech/v1beta1/version"
require "google/cloud/text_to_speech/v1beta1/text_to_speech/paths"
require "google/cloud/text_to_speech/v1beta1/text_to_speech_long_audio_synthesize/paths"

# 1. VERSION
puts Google::Cloud::TextToSpeech::V1beta1::VERSION

# 2. TextToSpeech::Paths#model_path — happy path
path = Google::Cloud::TextToSpeech::V1beta1::TextToSpeech::Paths.model_path(
  project: "my-project",
  location: "us-central1",
  model: "chirp"
)
puts path

# 3. TextToSpeechLongAudioSynthesize::Paths#model_path — happy path
path2 = Google::Cloud::TextToSpeech::V1beta1::TextToSpeechLongAudioSynthesize::Paths.model_path(
  project: "acme-corp",
  location: "europe-west1",
  model: "studio"
)
puts path2

# 4. model_path raises ArgumentError when project contains "/"
begin
  Google::Cloud::TextToSpeech::V1beta1::TextToSpeech::Paths.model_path(
    project: "bad/project",
    location: "us-central1",
    model: "chirp"
  )
  puts "ERROR: should have raised"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# 5. model_path raises ArgumentError when location contains "/"
begin
  Google::Cloud::TextToSpeech::V1beta1::TextToSpeech::Paths.model_path(
    project: "my-project",
    location: "us/central1",
    model: "chirp"
  )
  puts "ERROR: should have raised"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# frozen_string_literal: true
# Smoke test for google-cloud-text_to_speech-v1
# Exercises: VERSION constant, TextToSpeech::Paths.model_path,
#            TextToSpeechLongAudioSynthesize::Paths.model_path,
#            ArgumentError guard for slashes in path components.
# No network, no gapic/protobuf deps required — paths.rb and version.rb are self-contained.

require "google/cloud/text_to_speech/v1/version"
require "google/cloud/text_to_speech/v1/text_to_speech/paths"
require "google/cloud/text_to_speech/v1/text_to_speech_long_audio_synthesize/paths"

# 1. VERSION
puts Google::Cloud::TextToSpeech::V1::VERSION

# 2. TextToSpeech::Paths — model_path helper
p1 = Google::Cloud::TextToSpeech::V1::TextToSpeech::Paths
  .model_path(project: "my-project", location: "us-central1", model: "standard-a")
puts p1

# 3. TextToSpeechLongAudioSynthesize::Paths — same helper, different namespace
p2 = Google::Cloud::TextToSpeech::V1::TextToSpeechLongAudioSynthesize::Paths
  .model_path(project: "another-project", location: "europe-west1", model: "wavenet-b")
puts p2

# 4. ArgumentError when project contains a slash
begin
  Google::Cloud::TextToSpeech::V1::TextToSpeech::Paths
    .model_path(project: "bad/project", location: "us-central1", model: "x")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# 5. ArgumentError when location contains a slash
begin
  Google::Cloud::TextToSpeech::V1::TextToSpeech::Paths
    .model_path(project: "ok-project", location: "us/central1", model: "y")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

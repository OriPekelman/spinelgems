# frozen_string_literal: true
# Smoke: google-cloud-translate-v3
# Exercises the self-contained TranslationService::Paths module (resource-name
# helpers). No network, no gapic/gRPC deps required.
# Runs from the gem root; require_relative inlines the files into Spinel.

require_relative "lib/google/cloud/translate/v3/version"
require_relative "lib/google/cloud/translate/v3/translation_service/paths"

m = Google::Cloud::Translate::V3::TranslationService::Paths

# Resource path builders — deterministic string formatting
puts m.location_path(project: "acme", location: "us-central1")
puts m.glossary_path(project: "acme", location: "us-east1", glossary: "my-gl")
puts m.dataset_path(project: "acme", location: "eu-west3", dataset: "ds-42")
puts m.model_path(project: "acme", location: "us-central1", model: "general-en")
puts m.adaptive_mt_dataset_path(project: "acme", location: "us-central1", dataset: "mt-ds-1")
puts m.adaptive_mt_file_path(project: "acme", location: "us-central1", dataset: "mt-ds-1", file: "f1")
puts m.glossary_entry_path(project: "acme", location: "us-central1", glossary: "my-gl", glossary_entry: "e1")

# Argument validation raises on embedded slashes
begin
  m.location_path(project: "bad/project", location: "us-central1")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

puts Google::Cloud::Translate::V3::VERSION

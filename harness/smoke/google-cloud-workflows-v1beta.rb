# frozen_string_literal: true
# Smoke test for google-cloud-workflows-v1beta
# Exercises path helpers and version constant — no network, no external deps beyond the gem itself.

require "google-cloud-workflows-v1beta"
require "google/cloud/workflows/v1beta/version"
require "google/cloud/workflows/v1beta/workflows/paths"

# 1. VERSION constant
puts Google::Cloud::Workflows::V1beta::VERSION

# 2. Path helpers — location_path
m = Google::Cloud::Workflows::V1beta::Workflows::Paths
puts m.location_path(project: "acme-corp", location: "us-east1")
puts m.location_path(project: "my-project", location: "europe-west1")

# 3. workflow_path — nominal
puts m.workflow_path(project: "acme-corp", location: "us-east1", workflow: "daily-report")
puts m.workflow_path(project: "my-project", location: "europe-west1", workflow: "ingestion-pipeline")

# 4. workflow_path — project contains "/" should raise ArgumentError
begin
  m.workflow_path(project: "bad/project", location: "us-east1", workflow: "w")
  puts "NO_ERROR"
rescue ArgumentError => e
  puts "ArgumentError:project_slash"
end

# 5. location_path — project contains "/" should raise ArgumentError
begin
  m.location_path(project: "also/bad", location: "us-east1")
  puts "NO_ERROR"
rescue ArgumentError => e
  puts "ArgumentError:location_project_slash"
end

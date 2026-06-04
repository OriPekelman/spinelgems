# frozen_string_literal: true

# Smoke test for google-cloud-kms-v1
# Exercises the pure-Ruby Paths helpers that build GCP resource name strings.
# These modules have no external gem dependencies (gapic/common etc. are not needed).

require "google/cloud/kms/v1/key_management_service/paths"
require "google/cloud/kms/v1/ekm_service/paths"
require "google/cloud/kms/v1/autokey/paths"
require "google/cloud/kms/v1/autokey_admin/paths"

# --- KeyManagementService::Paths ---
kms_paths = Google::Cloud::Kms::V1::KeyManagementService::Paths

puts kms_paths.key_ring_path(project: "my-project", location: "us-east1", key_ring: "my-ring")
puts kms_paths.crypto_key_path(project: "my-project", location: "us-east1", key_ring: "my-ring", crypto_key: "my-key")
puts kms_paths.crypto_key_version_path(project: "my-project", location: "us-east1", key_ring: "my-ring", crypto_key: "my-key", crypto_key_version: "3")
puts kms_paths.import_job_path(project: "my-project", location: "us-east1", key_ring: "my-ring", import_job: "job-1")
puts kms_paths.location_path(project: "my-project", location: "us-east1")

# --- EkmService::Paths ---
ekm_paths = Google::Cloud::Kms::V1::EkmService::Paths

puts ekm_paths.ekm_config_path(project: "my-project", location: "us-east1")
puts ekm_paths.ekm_connection_path(project: "my-project", location: "us-east1", ekm_connection: "my-ekm")
puts ekm_paths.service_path(project: "my-project", location: "us-east1", namespace: "my-ns", service: "my-svc")

# --- Autokey::Paths ---
ak_paths = Google::Cloud::Kms::V1::Autokey::Paths

puts ak_paths.crypto_key_path(project: "my-project", location: "us-east1", key_ring: "my-ring", crypto_key: "auto-key")
puts ak_paths.key_handle_path(project: "my-project", location: "us-east1", key_handle: "handle-1")
puts ak_paths.location_path(project: "my-project", location: "us-east1")

# --- AutokeyAdmin::Paths (overloaded path) ---
aka_paths = Google::Cloud::Kms::V1::AutokeyAdmin::Paths

puts aka_paths.autokey_config_path(folder: "my-folder")
puts aka_paths.autokey_config_path(project: "my-project")
puts aka_paths.project_path(project: "my-project")

# Validate that ArgumentError is raised for slash-containing inputs
begin
  kms_paths.key_ring_path(project: "bad/project", location: "us", key_ring: "ring")
  puts "ERROR: expected ArgumentError"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# frozen_string_literal: true

# Smoke test for google-cloud-document_ai-v1beta3
# Exercises real path-builder methods from the Paths modules (pure string logic, no network).

require "google/cloud/document_ai/v1beta3/document_processor_service/paths"
require "google/cloud/document_ai/v1beta3/document_service/paths"
require "google/cloud/document_ai/v1beta3/version"

# --- DocumentProcessorService::Paths ---
mod_dps = Google::Cloud::DocumentAI::V1beta3::DocumentProcessorService::Paths

loc = mod_dps.location_path(project: "my-project", location: "us-central1")
puts loc

proc_path = mod_dps.processor_path(project: "my-project", location: "us-central1", processor: "abc123")
puts proc_path

proc_ver_path = mod_dps.processor_version_path(
  project: "my-project",
  location: "us-central1",
  processor: "abc123",
  processor_version: "v1"
)
puts proc_ver_path

eval_path = mod_dps.evaluation_path(
  project: "my-project",
  location: "us-central1",
  processor: "abc123",
  processor_version: "v1",
  evaluation: "eval456"
)
puts eval_path

hr_path = mod_dps.human_review_config_path(project: "my-project", location: "us-central1", processor: "abc123")
puts hr_path

pt_path = mod_dps.processor_type_path(project: "my-project", location: "us-central1", processor_type: "INVOICE_PARSER")
puts pt_path

# --- DocumentService::Paths ---
mod_ds = Google::Cloud::DocumentAI::V1beta3::DocumentService::Paths

ds_path = mod_ds.dataset_path(project: "my-project", location: "us-central1", processor: "abc123")
puts ds_path

dss_path = mod_ds.dataset_schema_path(project: "my-project", location: "us-central1", processor: "abc123")
puts dss_path

schema_path = mod_ds.schema_path(project: "my-project", location: "us-central1", schema: "schema789")
puts schema_path

# --- Argument validation: slash rejection ---
begin
  mod_dps.processor_path(project: "bad/project", location: "us", processor: "p1")
  puts "ERROR: should have raised"
rescue ArgumentError => e
  puts "ArgError: #{e.message}"
end

# --- Version constant ---
puts Google::Cloud::DocumentAI::V1beta3::VERSION

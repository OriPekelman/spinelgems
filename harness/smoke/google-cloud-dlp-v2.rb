# frozen_string_literal: true

# Smoke: google-cloud-dlp-v2
# Exercises pure-Ruby path helpers from DlpService::Paths — no gRPC, no network.
# The Paths module uses `extend self` so all path helpers are module methods.

require "google/cloud/dlp/v2/version"
require "google/cloud/dlp/v2/dlp_service/paths"

puts Google::Cloud::Dlp::V2::VERSION

mod = Google::Cloud::Dlp::V2::DlpService::Paths

# project_path — simple single-segment helper
puts mod.project_path(project: "my-project")

# location_path — two-segment helper
puts mod.location_path(project: "acme", location: "us-central1")

# organization_path — single-segment
puts mod.organization_path(organization: "123456789")

# organization_location_path — two-segment under organizations/
puts mod.organization_location_path(organization: "987654321", location: "europe-west1")

# dlp_job_path — overloaded: project-only variant
puts mod.dlp_job_path(project: "p1", dlp_job: "job42")

# dlp_job_path — overloaded: project+location variant
puts mod.dlp_job_path(project: "p2", location: "us-east1", dlp_job: "job99")

# inspect_template_path — project-only variant
puts mod.inspect_template_path(project: "p3", inspect_template: "tmpl-a")

# inspect_template_path — org+location variant
puts mod.inspect_template_path(organization: "111", location: "asia-east1", inspect_template: "tmpl-b")

# stored_info_type_path — project+location variant
puts mod.stored_info_type_path(project: "p4", location: "us-west1", stored_info_type: "sit1")

# deidentify_template_path — project-only variant
puts mod.deidentify_template_path(project: "p5", deidentify_template: "dt1")

# table_data_profile_path — project+location
puts mod.table_data_profile_path(project: "p6", location: "northamerica-northeast1", table_data_profile: "tdp1")

# discovery_config_path — single overload
puts mod.discovery_config_path(project: "p7", location: "us", discovery_config: "dc1")

# Verify ArgumentError raised on "/" in a segment (location_path validates project)
begin
  mod.location_path(project: "bad/project", location: "us-central1")
  puts "ERROR: expected ArgumentError not raised"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

puts "ok"

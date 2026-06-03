# frozen_string_literal: true
# Smoke: google-cloud-logging-v2
# Exercises path-helper modules (extend self) for LoggingService, ConfigService,
# and MetricsService — all pure string-interpolation logic, no network, no gRPC.

require "google/cloud/logging/v2/version"
require "google/cloud/logging/v2/logging_service/paths"
require "google/cloud/logging/v2/config_service/paths"
require "google/cloud/logging/v2/metrics_service/paths"

puts Google::Cloud::Logging::V2::VERSION

# --- LoggingService::Paths ---
lp = Google::Cloud::Logging::V2::LoggingService::Paths

puts lp.project_path(project: "my-project")
puts lp.billing_account_path(billing_account: "012345")
puts lp.folder_path(folder: "789")
puts lp.organization_path(organization: "42")

# log_path — multi-variant dispatch via sorted key join
puts lp.log_path(project: "my-project", log: "cloudaudit.googleapis.com%2Factivity")
puts lp.log_path(folder: "789", log: "appengine.googleapis.com%2Frequest_log")
puts lp.log_path(billing_account: "012345", log: "my-log")

# --- ConfigService::Paths ---
cp = Google::Cloud::Logging::V2::ConfigService::Paths

puts cp.billing_account_path(billing_account: "012345")
puts cp.billing_account_location_path(billing_account: "012345", location: "us-east1")
puts cp.folder_path(folder: "789")
puts cp.folder_location_path(folder: "789", location: "global")
puts cp.project_path(project: "my-project")
puts cp.organization_path(organization: "42")
puts cp.organization_location_path(organization: "42", location: "us-central1")
puts cp.location_path(project: "my-project", location: "us-east1")

# log_sink_path — multi-variant
puts cp.log_sink_path(project: "my-project", sink: "my-sink")
puts cp.log_sink_path(organization: "42", sink: "org-sink")
puts cp.log_sink_path(folder: "789", sink: "folder-sink")
puts cp.log_sink_path(billing_account: "012345", sink: "ba-sink")

# log_exclusion_path — multi-variant
puts cp.log_exclusion_path(project: "my-project", exclusion: "my-excl")
puts cp.log_exclusion_path(organization: "42", exclusion: "org-excl")

# log_bucket_path — multi-variant
puts cp.log_bucket_path(project: "my-project", location: "us-east1", bucket: "_Default")
puts cp.log_bucket_path(folder: "789", location: "global", bucket: "_Required")

# log_view_path
puts cp.log_view_path(project: "my-project", location: "us-east1", bucket: "_Default", view: "_AllLogs")

# cmek_settings_path
puts cp.cmek_settings_path(project: "my-project")
puts cp.cmek_settings_path(organization: "42")

# settings_path
puts cp.settings_path(project: "my-project")
puts cp.settings_path(folder: "789")

# --- MetricsService::Paths ---
mp = Google::Cloud::Logging::V2::MetricsService::Paths

puts mp.project_path(project: "my-project")
puts mp.log_metric_path(project: "my-project", metric: "my-metric")

# --- Error-path guard: slash in billing_account raises ArgumentError ---
begin
  cp.billing_account_location_path(billing_account: "bad/id", location: "us-east1")
  puts "ERROR: expected ArgumentError"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

puts "done"

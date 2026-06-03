# frozen_string_literal: true
# Smoke: google-cloud-error_reporting-v1beta1
# Exercises path helper modules (pure string logic, no network/gRPC).
# These are the publicly documented helper methods users call to build
# resource names before passing them to the service clients.

require "google/cloud/error_reporting/v1beta1/error_group_service/paths"
require "google/cloud/error_reporting/v1beta1/error_stats_service/paths"
require "google/cloud/error_reporting/v1beta1/report_errors_service/paths"
require "google/cloud/error_reporting/v1beta1/version"

# --- Version ---
puts Google::Cloud::ErrorReporting::V1beta1::VERSION

# --- ErrorGroupService::Paths ---
eg_paths = Google::Cloud::ErrorReporting::V1beta1::ErrorGroupService::Paths

path1 = eg_paths.error_group_path(project: "my-project", group: "group-abc")
puts path1

path2 = eg_paths.error_group_path(project: "another-proj", group: "grp-999")
puts path2

# Verify ArgumentError raised for slash in project
begin
  eg_paths.error_group_path(project: "bad/project", group: "g")
  puts "no_error"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# --- ErrorStatsService::Paths ---
es_paths = Google::Cloud::ErrorReporting::V1beta1::ErrorStatsService::Paths

puts es_paths.project_path(project: "stats-project")
puts es_paths.project_path(project: "another-stats-project")

# --- ReportErrorsService::Paths ---
re_paths = Google::Cloud::ErrorReporting::V1beta1::ReportErrorsService::Paths

puts re_paths.project_path(project: "report-project")
puts re_paths.project_path(project: "my-gcp-project-123")

# frozen_string_literal: true
# Smoke: google-cloud-trace-v2
# Exercises the self-contained TraceService::Paths module (no gRPC/network deps)
# and the VERSION constant.

require "google/cloud/trace/v2/trace_service/paths"
require "google/cloud/trace/v2/version"

include Google::Cloud::Trace::V2::TraceService::Paths

# project_path helper
puts project_path(project: "my-gcp-project")

# span_path helper: two spans in the same trace
puts span_path(project: "my-gcp-project", trace: "abc123def456", span: "0000000000000001")
puts span_path(project: "my-gcp-project", trace: "abc123def456", span: "0000000000000002")

# span_path raises ArgumentError when project contains "/"
begin
  span_path(project: "bad/project", trace: "abc", span: "span")
  puts "ERROR: should have raised"
rescue ArgumentError => e
  puts "ArgumentError caught: #{e.message}"
end

# span_path raises ArgumentError when trace contains "/"
begin
  span_path(project: "good-project", trace: "bad/trace", span: "span")
  puts "ERROR: should have raised"
rescue ArgumentError => e
  puts "ArgumentError caught: #{e.message}"
end

puts Google::Cloud::Trace::V2::VERSION

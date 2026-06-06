# frozen_string_literal: true
# Smoke test for google-cloud-web_risk-v1
# Exercises the Paths helper module (project_path) and VERSION constant.
# Stays self-contained: no network, no gRPC, no external gems.

require "google/cloud/web_risk/v1/version"
require "google/cloud/web_risk/v1/web_risk_service/paths"

# --- VERSION ---
ver = Google::Cloud::WebRisk::V1::VERSION
puts "version: #{ver}"
raise "version blank" if ver.nil? || ver.empty?

# --- Paths module ---
paths = Google::Cloud::WebRisk::V1::WebRiskService::Paths

# Single project
p1 = paths.project_path(project: "my-project-123")
puts "project_path(my-project-123): #{p1}"
raise "bad prefix" unless p1.start_with?("projects/")
raise "bad id"     unless p1.end_with?("my-project-123")

# Numeric-looking project id
p2 = paths.project_path(project: "987654321")
puts "project_path(987654321): #{p2}"
raise "numeric mismatch" unless p2 == "projects/987654321"

# Special chars (hyphens and underscores are valid in GCP project ids)
p3 = paths.project_path(project: "acme-corp_prod")
puts "project_path(acme-corp_prod): #{p3}"
raise "special char path wrong" unless p3 == "projects/acme-corp_prod"

# Confirm it is a plain string
raise "not string" unless p1.is_a?(String) && p2.is_a?(String)

puts "ok"

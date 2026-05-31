# Smoke: google-cloud-monitoring-v3 — version constant (no external deps)
require_relative "lib/google/cloud/monitoring/v3/version"

puts Google::Cloud::Monitoring::V3::VERSION
puts Google::Cloud::Monitoring::V3::VERSION.class
puts Google::Cloud::Monitoring::V3::VERSION.split(".").length
puts Google::Cloud::Monitoring::V3::VERSION =~ /\A\d+\.\d+\.\d+\z/ ? "semver" : "other"

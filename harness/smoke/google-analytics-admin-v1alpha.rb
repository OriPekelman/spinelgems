# frozen_string_literal: true
# Smoke: google-analytics-admin-v1alpha
# Tests the Paths module path-helper methods — pure string interpolation,
# no network or external gem deps.

require "google/analytics/admin/v1alpha/version"
require "google/analytics/admin/v1alpha/analytics_admin_service/paths"

include Google::Analytics::Admin::V1alpha::AnalyticsAdminService::Paths

# VERSION constant
puts Google::Analytics::Admin::V1alpha::VERSION

# account_path — simple interpolation
puts account_path(account: "123")

# property_path
puts property_path(property: "456")

# access_binding_path — dispatches on keyword set (account variant)
puts access_binding_path(account: "123", access_binding: "bind1")

# access_binding_path — property variant
puts access_binding_path(property: "456", access_binding: "bind2")

# data_stream_path — two-segment, guard on slash in property
puts data_stream_path(property: "456", data_stream: "789")

# data_retention_settings_path
puts data_retention_settings_path(property: "456")

# measurement_protocol_secret_path — three segments
puts measurement_protocol_secret_path(
  property: "456",
  data_stream: "789",
  measurement_protocol_secret: "secret42"
)

# Verify the slash-guard raises for invalid input
begin
  data_stream_path(property: "a/b", data_stream: "ds1")
  puts "ERROR: expected ArgumentError not raised"
rescue ArgumentError => e
  puts "guard:#{e.message}"
end

# event_create_rule_path — three segments, two guards
puts event_create_rule_path(property: "p1", data_stream: "ds1", event_create_rule: "rule1")

# organization_path
puts organization_path(organization: "org99")

# google_signals_settings_path
puts google_signals_settings_path(property: "p99")

# subproperty_event_filter_path
puts subproperty_event_filter_path(property: "p1", sub_property_event_filter: "f1")

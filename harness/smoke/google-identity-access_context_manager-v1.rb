# frozen_string_literal: true

# Smoke test for google-identity-access_context_manager-v1
# Exercises the Paths module which provides pure path-building helpers.
# The main entry point does not autoload, so we require the paths file directly.

require "google/identity/access_context_manager/v1/access_context_manager/paths"

mod = Google::Identity::AccessContextManager::V1::AccessContextManager::Paths

# access_level_path
puts mod.access_level_path(access_policy: "123456789", access_level: "MY_LEVEL")

# access_policy_path
puts mod.access_policy_path(access_policy: "987654321")

# gcp_user_access_binding_path
puts mod.gcp_user_access_binding_path(organization: "111222333", gcp_user_access_binding: "binding-abc")

# organization_path
puts mod.organization_path(organization: "444555666")

# service_perimeter_path
puts mod.service_perimeter_path(access_policy: "123456789", service_perimeter: "MY_PERIMETER")

# Verify error on slash in access_policy for access_level_path
begin
  mod.access_level_path(access_policy: "bad/policy", access_level: "LEVEL")
  puts "ERROR: expected ArgumentError not raised"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# Verify error on slash in organization for gcp_user_access_binding_path
begin
  mod.gcp_user_access_binding_path(organization: "bad/org", gcp_user_access_binding: "bind")
  puts "ERROR: expected ArgumentError not raised"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# Verify error on slash in access_policy for service_perimeter_path
begin
  mod.service_perimeter_path(access_policy: "bad/policy", service_perimeter: "PERIMETER")
  puts "ERROR: expected ArgumentError not raised"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

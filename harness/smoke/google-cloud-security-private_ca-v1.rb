# frozen_string_literal: true

# Smoke: google-cloud-security-private_ca-v1
# Exercises the path helper methods in CertificateAuthorityService::Paths.
# These are pure string-formatting methods with no network or external deps.
#
# The top-level require is a stub (gem comment only). Load the paths module
# directly via require_relative so Spinel can inline it without gapic deps.

require "google-cloud-security-private_ca-v1"
require "google/cloud/security/private_ca/v1/version"
require "google/cloud/security/private_ca/v1/certificate_authority_service/paths"

include Google::Cloud::Security::PrivateCA::V1::CertificateAuthorityService::Paths

# 1. ca_pool_path
p1 = ca_pool_path(project: "my-project", location: "us-east1", ca_pool: "root-pool")
puts "ca_pool_path: #{p1}"

# 2. certificate_path
p2 = certificate_path(project: "my-project", location: "us-east1", ca_pool: "root-pool", certificate: "cert-001")
puts "certificate_path: #{p2}"

# 3. certificate_authority_path
p3 = certificate_authority_path(project: "my-project", location: "us-central1", ca_pool: "intermediate-pool", certificate_authority: "sub-ca")
puts "certificate_authority_path: #{p3}"

# 4. certificate_revocation_list_path
p4 = certificate_revocation_list_path(project: "my-project", location: "us-east1", ca_pool: "root-pool", certificate_authority: "sub-ca", certificate_revocation_list: "crl-v1")
puts "certificate_revocation_list_path: #{p4}"

# 5. certificate_template_path
p5 = certificate_template_path(project: "my-project", location: "us-east1", certificate_template: "leaf-tls")
puts "certificate_template_path: #{p5}"

# 6. location_path
p6 = location_path(project: "my-project", location: "europe-west1")
puts "location_path: #{p6}"

# 7. Verify error raised for path component containing "/"
begin
  ca_pool_path(project: "bad/project", location: "us-east1", ca_pool: "pool")
  puts "ERROR: should have raised"
rescue ArgumentError => e
  puts "ArgumentError raised: #{e.message}"
end

puts "VERSION: #{Google::Cloud::Security::PrivateCA::V1::VERSION}"

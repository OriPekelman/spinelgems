# frozen_string_literal: true
# Smoke: VERSION constant + pure path-helper methods (no external deps)

require_relative "lib/google/cloud/security/private_ca/v1beta1/version"
require_relative "lib/google/cloud/security/private_ca/v1beta1/certificate_authority_service/paths"

puts Google::Cloud::Security::PrivateCA::V1beta1::VERSION

m = Google::Cloud::Security::PrivateCA::V1beta1::CertificateAuthorityService::Paths

puts m.certificate_path(
  project: "my-project",
  location: "us-east1",
  certificate_authority: "my-ca",
  certificate: "my-cert"
)

puts m.certificate_authority_path(
  project: "my-project",
  location: "us-east1",
  certificate_authority: "my-ca"
)

puts m.location_path(project: "my-project", location: "us-east1")

puts m.reusable_config_path(
  project: "my-project",
  location: "us-east1",
  reusable_config: "my-config"
)

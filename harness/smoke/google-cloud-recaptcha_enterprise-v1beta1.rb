# Smoke: google-cloud-recaptcha_enterprise-v1beta1 — version constant + pure path helpers (no external deps)
require_relative "lib/google/cloud/recaptcha_enterprise/v1beta1/version"
require_relative "lib/google/cloud/recaptcha_enterprise/v1beta1/recaptcha_enterprise_service/paths"

puts Google::Cloud::RecaptchaEnterprise::V1beta1::VERSION

include Google::Cloud::RecaptchaEnterprise::V1beta1::RecaptchaEnterpriseService::Paths

puts assessment_path(project: "my-project", assessment: "my-assessment")
puts project_path(project: "test-proj")

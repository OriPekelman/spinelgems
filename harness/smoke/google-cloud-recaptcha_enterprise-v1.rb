# frozen_string_literal: true
# Smoke: google-cloud-recaptcha_enterprise-v1
# Exercises the self-contained Paths module (no gRPC / gapic deps needed).

require "google/cloud/recaptcha_enterprise/v1/recaptcha_enterprise_service/paths"

mod = Google::Cloud::RecaptchaEnterprise::V1::RecaptchaEnterpriseService::Paths

# assessment_path
puts mod.assessment_path(project: "my-project", assessment: "assess-001")

# firewall_policy_path
puts mod.firewall_policy_path(project: "my-project", firewallpolicy: "fp-42")

# key_path
puts mod.key_path(project: "my-project", key: "site-key-abc")

# metrics_path
puts mod.metrics_path(project: "my-project", key: "site-key-abc")

# project_path
puts mod.project_path(project: "my-project")

# related_account_group_path
puts mod.related_account_group_path(project: "my-project", relatedaccountgroup: "group-7")

# ArgumentError when project contains a slash
begin
  mod.key_path(project: "bad/project", key: "k")
  puts "NO_ERROR"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# frozen_string_literal: true

# Smoke: google-iam-credentials-v1
# Exercises the self-contained Paths helper module which constructs
# fully-qualified resource strings — no network, no gRPC, no external deps.

require "google-iam-credentials-v1"
require "google/iam/credentials/v1/version"
require "google/iam/credentials/v1/iam_credentials/paths"

# VERSION constant
puts Google::Iam::Credentials::V1::VERSION

# service_account_path with plain project + SA name
path1 = Google::Iam::Credentials::V1::IAMCredentials::Paths
          .service_account_path(project: "my-project", service_account: "deployer@my-project.iam.gserviceaccount.com")
puts path1

# service_account_path with numeric project ID
path2 = Google::Iam::Credentials::V1::IAMCredentials::Paths
          .service_account_path(project: "123456789", service_account: "robot@123456789.iam.gserviceaccount.com")
puts path2

# Verify that a project with "/" is rejected
begin
  Google::Iam::Credentials::V1::IAMCredentials::Paths
    .service_account_path(project: "bad/project", service_account: "sa@example.iam.gserviceaccount.com")
  puts "ERROR: expected ArgumentError"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# Verify the module is extended (module-function style — callable on the module itself)
path3 = Google::Iam::Credentials::V1::IAMCredentials::Paths
          .service_account_path(project: "prod", service_account: "ci-runner@prod.iam.gserviceaccount.com")
puts path3

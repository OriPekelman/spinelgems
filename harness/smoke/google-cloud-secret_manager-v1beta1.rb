# frozen_string_literal: true

# Smoke: google-cloud-secret_manager-v1beta1
# Exercises the self-contained Paths module (resource-name helpers) and VERSION.
# The gRPC/REST client requires gapic-common which is not available without
# bundler, so we load only the parts that carry real logic without network deps.

require "google/cloud/secret_manager/v1beta1/version"
require "google/cloud/secret_manager/v1beta1/secret_manager_service/paths"

Paths = Google::Cloud::SecretManager::V1beta1::SecretManagerService::Paths

# 1. VERSION constant
puts Google::Cloud::SecretManager::V1beta1::VERSION

# 2. project_path
puts Paths.project_path(project: "acme-prod")

# 3. secret_path
puts Paths.secret_path(project: "acme-prod", secret: "db-password")

# 4. secret_version_path (latest alias and a numeric version)
puts Paths.secret_version_path(project: "acme-prod", secret: "db-password", secret_version: "latest")
puts Paths.secret_version_path(project: "acme-prod", secret: "db-password", secret_version: "7")

# 5. Argument validation — slash in project raises ArgumentError
begin
  Paths.secret_path(project: "bad/project", secret: "s")
  puts "FAIL: expected ArgumentError"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# 6. Argument validation — slash in secret raises ArgumentError
begin
  Paths.secret_version_path(project: "p", secret: "bad/secret", secret_version: "1")
  puts "FAIL: expected ArgumentError"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

puts "ok"

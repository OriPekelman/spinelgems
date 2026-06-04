# frozen_string_literal: true
# Smoke: google-cloud-secret_manager-v1
# Exercises the self-contained Paths module (resource name builders + validation).
# The gRPC/REST client layers require gapic/grpc which are unavailable without
# bundler, so we load only the parts that have no external runtime deps.

require "google/cloud/secret_manager/v1/version"
require "google/cloud/secret_manager/v1/secret_manager_service/paths"

# VERSION constant
puts Google::Cloud::SecretManager::V1::VERSION

# Paths module is mixed in via extend self — call methods directly on the module
p = Google::Cloud::SecretManager::V1::SecretManagerService::Paths

# project_path
puts p.project_path(project: "my-project")

# location_path
puts p.location_path(project: "my-project", location: "us-east1")

# topic_path
puts p.topic_path(project: "my-project", topic: "my-topic")

# secret_path: project+secret form
puts p.secret_path(project: "my-project", secret: "my-secret")

# secret_path: project+location+secret form (regional)
puts p.secret_path(project: "my-project", location: "us-central1", secret: "regional-secret")

# secret_version_path: project+secret+version form
puts p.secret_version_path(project: "my-project", secret: "my-secret", secret_version: "latest")
puts p.secret_version_path(project: "my-project", secret: "my-secret", secret_version: "42")

# secret_version_path: project+location+secret+version form (regional)
puts p.secret_version_path(project: "my-project", location: "europe-west1", secret: "regional-secret", secret_version: "7")

# Validation guards: slashes in component parts raise ArgumentError
begin
  p.location_path(project: "bad/project", location: "us-east1")
rescue ArgumentError => e
  puts "ArgErr(project-in-location): #{e.message}"
end

begin
  p.secret_path(project: "bad/project", secret: "my-secret")
rescue ArgumentError => e
  puts "ArgErr(project-in-secret): #{e.message}"
end

begin
  p.secret_version_path(project: "my-project", secret: "bad/secret", secret_version: "1")
rescue ArgumentError => e
  puts "ArgErr(secret-in-version): #{e.message}"
end

begin
  p.topic_path(project: "bad/proj", topic: "t")
rescue ArgumentError => e
  puts "ArgErr(project-in-topic): #{e.message}"
end

# Unknown key combo raises ArgumentError
begin
  p.secret_path(project: "x", bad_key: "y")
rescue ArgumentError => e
  puts "ArgErr(unknown-keys): #{e.message}"
end

puts "done"

# frozen_string_literal: true
# Smoke: google-cloud-run-v2
# Exercises path-helper modules (Services, Jobs, Builds) — pure Ruby, no network.
# These are the primary public API surface used before constructing any client.

require "google/cloud/run/v2/version"
require "google/cloud/run/v2/services/paths"
require "google/cloud/run/v2/jobs/paths"
require "google/cloud/run/v2/builds/paths"

puts Google::Cloud::Run::V2::VERSION

SP = Google::Cloud::Run::V2::Services::Paths
JP = Google::Cloud::Run::V2::Jobs::Paths
BP = Google::Cloud::Run::V2::Builds::Paths

# Services paths
puts SP.service_path(project: "my-project", location: "us-central1", service: "my-service")
puts SP.revision_path(project: "my-project", location: "us-central1", service: "my-service", revision: "rev-1")
puts SP.secret_path(project: "my-project", secret: "db-password")
puts SP.secret_version_path(project: "my-project", secret: "db-password", version: "3")
puts SP.location_path(project: "my-project", location: "europe-west1")
puts SP.policy_path(project: "my-project")
puts SP.policy_path(location: "us-central1")

# Jobs paths
puts JP.job_path(project: "my-project", location: "us-east1", job: "my-job")
puts JP.execution_path(project: "my-project", location: "us-east1", job: "my-job", execution: "exec-001")
puts JP.secret_version_path(project: "my-project", secret: "job-secret", version: "latest")

# Builds paths
puts BP.build_worker_pool_path(project: "my-project", location: "us-central1", worker_pool: "pool-1")

# Validation guard: slash in project raises ArgumentError
begin
  SP.service_path(project: "bad/project", location: "us-central1", service: "svc")
  puts "ERROR: expected ArgumentError"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

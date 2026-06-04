# frozen_string_literal: true
# Smoke: google-cloud-spanner-admin-instance-v1
# Exercises the Paths helper module (pure Ruby, no network/gRPC deps)
# and the VERSION constant.
# The top-level require is a no-op stub; we require the actual sub-paths
# which live inside this gem.

require "google/cloud/spanner/admin/instance/v1/version"
require "google/cloud/spanner/admin/instance/v1/instance_admin/paths"

include Google::Cloud::Spanner::Admin::Instance::V1::InstanceAdmin::Paths

# 1. VERSION constant
puts Google::Cloud::Spanner::Admin::Instance::V1::VERSION

# 2. instance_path — normal case
puts instance_path(project: "my-project", instance: "my-instance")

# 3. instance_config_path — normal case
puts instance_config_path(project: "acme", instance_config: "regional-us-central1")

# 4. instance_partition_path — normal case
puts instance_partition_path(project: "acme", instance: "prod", instance_partition: "shard-1")

# 5. project_path — normal case
puts project_path(project: "acme-123")

# 6. ArgumentError when project contains slash
begin
  instance_path(project: "bad/project", instance: "x")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# 7. ArgumentError when instance contains slash in instance_partition_path
begin
  instance_partition_path(project: "p", instance: "bad/inst", instance_partition: "x")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# 8. project_path with numeric-suffix project
puts project_path(project: "proj-99")

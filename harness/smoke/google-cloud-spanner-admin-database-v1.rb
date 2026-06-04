# Smoke: google-cloud-spanner-admin-database-v1
# Exercises the self-contained Paths module (resource string builders)
# and the VERSION constant — no network, no gapic/grpc deps needed.

require "google/cloud/spanner/admin/database/v1/version"
require "google/cloud/spanner/admin/database/v1/database_admin/paths"

paths = Google::Cloud::Spanner::Admin::Database::V1::DatabaseAdmin::Paths

# VERSION
puts Google::Cloud::Spanner::Admin::Database::V1::VERSION

# backup_path — 3-segment resource name
puts paths.backup_path(project: "my-project", instance: "my-instance", backup: "my-backup")

# database_path
puts paths.database_path(project: "my-project", instance: "my-instance", database: "my-db")

# instance_path — 2-segment
puts paths.instance_path(project: "my-project", instance: "my-instance")

# backup_schedule_path — 4-segment with nested path under database
puts paths.backup_schedule_path(
  project: "acme",
  instance: "prod",
  database: "analytics",
  schedule: "daily"
)

# instance_partition_path
puts paths.instance_partition_path(
  project: "my-project",
  instance: "my-instance",
  instance_partition: "part-1"
)

# crypto_key_path — KMS resource name
puts paths.crypto_key_path(
  project: "my-project",
  location: "us-east1",
  key_ring: "my-ring",
  crypto_key: "my-key"
)

# crypto_key_version_path — full version path
puts paths.crypto_key_version_path(
  project: "my-project",
  location: "us-east1",
  key_ring: "my-ring",
  crypto_key: "my-key",
  crypto_key_version: "1"
)

# ArgumentError on slash-in-component validation
begin
  paths.backup_path(project: "bad/project", instance: "inst", backup: "bak")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

begin
  paths.database_path(project: "proj", instance: "bad/instance", database: "db")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

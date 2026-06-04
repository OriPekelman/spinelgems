# frozen_string_literal: true
# Smoke: google-cloud-container-v1beta1
# Exercises the self-contained ClusterManager::Paths module — pure string
# interpolation helpers with validation guards. No network, no gapic dep.

require "google-cloud-container-v1beta1"
require "google/cloud/container/v1beta1/cluster_manager/paths"
require "google/cloud/container/v1beta1/version"

include Google::Cloud::Container::V1beta1::ClusterManager::Paths

# 1. ca_pool_path
puts ca_pool_path(project: "my-project", location: "us-central1", ca_pool: "main-pool")

# 2. subnetwork_path
puts subnetwork_path(project: "my-project", region: "us-west1", subnetwork: "default")

# 3. topic_path
puts topic_path(project: "my-project", topic: "gke-alerts")

# 4. crypto_key_version_path
puts crypto_key_version_path(
  project: "my-project",
  location: "us-east1",
  key_ring: "gke-ring",
  crypto_key: "node-key",
  crypto_key_version: "3"
)

# 5. Validation: slash in project raises ArgumentError
begin
  ca_pool_path(project: "bad/project", location: "us-central1", ca_pool: "pool")
  puts "FAIL: expected ArgumentError"
rescue ::ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# 6. Validation: slash in region raises ArgumentError
begin
  subnetwork_path(project: "proj", region: "us/west1", subnetwork: "net")
  puts "FAIL: expected ArgumentError"
rescue ::ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# 7. VERSION constant
puts Google::Cloud::Container::V1beta1::VERSION

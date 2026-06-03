# frozen_string_literal: true

# Smoke: google-cloud-storage_transfer-v1
# Exercises the Paths module (pure Ruby, no network/gapic deps) and VERSION.
# The main entry point requires gapic/common (external), so we require the
# sub-files that are self-contained.

require "google/cloud/storage_transfer/v1/version"
require "google/cloud/storage_transfer/v1/storage_transfer_service/paths"

# 1. VERSION string
puts Google::Cloud::StorageTransfer::V1::VERSION

# 2. agent_pools_path helper — builds a resource path string
p1 = Google::Cloud::StorageTransfer::V1::StorageTransferService::Paths
       .agent_pools_path(project_id: "my-project", agent_pool_id: "default-pool")
puts p1

# 3. Different project/pool names
p2 = Google::Cloud::StorageTransfer::V1::StorageTransferService::Paths
       .agent_pools_path(project_id: "acme-corp-123", agent_pool_id: "us-east1-pool")
puts p2

# 4. ArgumentError guard — project_id must not contain "/"
begin
  Google::Cloud::StorageTransfer::V1::StorageTransferService::Paths
    .agent_pools_path(project_id: "bad/id", agent_pool_id: "pool")
  puts "no_error"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

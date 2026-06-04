# frozen_string_literal: true
# Smoke: google-cloud-data_catalog-lineage-v1
# Exercises the path-builder helpers (pure logic, no network or gapic deps).

require "google-cloud-data_catalog-lineage-v1"
require "google/cloud/data_catalog/lineage/v1/lineage/paths"
require "google/cloud/data_catalog/lineage/v1/version"

# 1. VERSION constant
puts Google::Cloud::DataCatalog::Lineage::V1::VERSION

m = Google::Cloud::DataCatalog::Lineage::V1::Lineage::Paths

# 2. location_path
puts m.location_path(project: "my-project", location: "us-east1")

# 3. process_path
puts m.process_path(project: "my-project", location: "us-east1", process: "etl-proc")

# 4. run_path
puts m.run_path(project: "my-project", location: "us-east1",
                process: "etl-proc", run: "run-20240101")

# 5. lineage_event_path
puts m.lineage_event_path(project: "my-project", location: "us-east1",
                          process: "etl-proc", run: "run-20240101",
                          lineage_event: "evt-001")

# 6. ArgumentError on slash in project
begin
  m.process_path(project: "bad/project", location: "us-east1", process: "p")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# 7. ArgumentError on slash in location
begin
  m.run_path(project: "proj", location: "us/east1", process: "p", run: "r")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

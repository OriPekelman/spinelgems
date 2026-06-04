# frozen_string_literal: true
# Smoke test for google-cloud-dataplex-v1
# Exercises the path-helper modules (DataplexService::Paths and CatalogService::Paths)
# which are pure string-building logic with no external gem deps.

require "google/cloud/dataplex/v1/version"
require "google/cloud/dataplex/v1/dataplex_service/paths"
require "google/cloud/dataplex/v1/catalog_service/paths"
require "google/cloud/dataplex/v1/metadata_service/paths"

puts Google::Cloud::Dataplex::V1::VERSION

# --- DataplexService::Paths ---
dp = Google::Cloud::Dataplex::V1::DataplexService::Paths

puts dp.lake_path(project: "my-proj", location: "us-central1", lake: "my-lake")
puts dp.zone_path(project: "my-proj", location: "us-central1", lake: "my-lake", zone: "raw")
puts dp.asset_path(project: "my-proj", location: "us-central1", lake: "my-lake", zone: "raw", asset: "gcs-bucket")
puts dp.task_path(project: "my-proj", location: "us-central1", lake: "my-lake", task: "etl-task")
puts dp.job_path(project: "my-proj", location: "us-central1", lake: "my-lake", task: "etl-task", job: "run-01")
puts dp.environment_path(project: "my-proj", location: "us-central1", lake: "my-lake", environment: "spark-env")
puts dp.location_path(project: "my-proj", location: "us-central1")

# Validate that slash in a segment raises ArgumentError
begin
  dp.lake_path(project: "bad/proj", location: "us-central1", lake: "lake1")
  puts "ERROR: expected ArgumentError"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# --- CatalogService::Paths ---
cs = Google::Cloud::Dataplex::V1::CatalogService::Paths

puts cs.entry_group_path(project: "my-proj", location: "us-east1", entry_group: "group1")
puts cs.entry_path(project: "my-proj", location: "us-east1", entry_group: "group1", entry: "table-entry")
puts cs.entry_type_path(project: "my-proj", location: "us-east1", entry_type: "bigquery-table")
puts cs.aspect_type_path(project: "my-proj", location: "us-east1", aspect_type: "schema")
puts cs.glossary_path(project: "my-proj", location: "us-east1", glossary: "biz-glossary")
puts cs.entry_link_path(project: "my-proj", location: "us-east1", entry_group: "group1", entry_link: "link-42")
puts cs.metadata_job_path(project: "my-proj", location: "us-east1", metadata_job: "import-job")
puts cs.project_path(project: "my-proj")
puts cs.location_path(project: "my-proj", location: "us-east1")

# Slash guard on CatalogService
begin
  cs.entry_group_path(project: "ok", location: "us/east1", entry_group: "eg")
  puts "ERROR: expected ArgumentError"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# --- MetadataService::Paths ---
ms = Google::Cloud::Dataplex::V1::MetadataService::Paths

puts ms.entity_path(project: "my-proj", location: "us-central1", lake: "my-lake", zone: "raw", entity: "sales")
puts ms.partition_path(project: "my-proj", location: "us-central1", lake: "my-lake", zone: "raw", entity: "sales", partition: "dt=2024-01-01")
puts ms.zone_path(project: "my-proj", location: "us-central1", lake: "my-lake", zone: "raw")

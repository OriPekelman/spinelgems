require_relative "lib/google/cloud/ai_platform/v1/dataset_service/paths"

include Google::Cloud::AIPlatform::V1::DatasetService::Paths

puts dataset_path(project: "my-project", location: "us-central1", dataset: "123")
puts data_item_path(project: "my-project", location: "us-central1", dataset: "123", data_item: "item1")
puts annotation_spec_path(project: "proj", location: "us-east1", dataset: "ds1", annotation_spec: "spec42")
puts dataset_version_path(project: "proj", location: "eu-west1", dataset: "ds2", dataset_version: "v3")
puts location_path(project: "my-project", location: "us-central1")
puts saved_query_path(project: "proj", location: "us-east1", dataset: "ds1", saved_query: "sq99")

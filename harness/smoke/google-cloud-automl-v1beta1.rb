# frozen_string_literal: true
# Smoke test for google-cloud-automl-v1beta1
# Exercises pure-Ruby path helpers (no network, no gRPC needed).

require "google/cloud/automl/v1beta1/version"
require "google/cloud/automl/v1beta1/automl/paths"
require "google/cloud/automl/v1beta1/prediction_service/paths"

# 1. Version constant
puts Google::Cloud::AutoML::V1beta1::VERSION

automl_paths = Google::Cloud::AutoML::V1beta1::AutoML::Paths
pred_paths   = Google::Cloud::AutoML::V1beta1::PredictionService::Paths

# 2. dataset_path helper
puts automl_paths.dataset_path(project: "myproj", location: "us-central1", dataset: "ds123")

# 3. model_path helper (AutoML service)
puts automl_paths.model_path(project: "myproj", location: "us-central1", model: "mdl456")

# 4. model_evaluation_path helper
puts automl_paths.model_evaluation_path(
  project: "myproj", location: "us-central1", model: "mdl456", model_evaluation: "eval789"
)

# 5. model_path helper (PredictionService — same format, separate module)
puts pred_paths.model_path(project: "myproj", location: "us-central1", model: "mdl456")

# 6. annotation_spec_path helper
puts automl_paths.annotation_spec_path(
  project: "myproj", location: "us-central1", dataset: "ds123", annotation_spec: "ann001"
)

# 7. column_spec_path helper
puts automl_paths.column_spec_path(
  project: "myproj", location: "us-central1", dataset: "ds123", table_spec: "tbl1", column_spec: "col2"
)

# 8. table_spec_path helper
puts automl_paths.table_spec_path(
  project: "myproj", location: "us-central1", dataset: "ds123", table_spec: "tbl1"
)

# 9. location_path helper
puts automl_paths.location_path(project: "myproj", location: "us-central1")

# 10. Validation: project with "/" raises ArgumentError
begin
  automl_paths.dataset_path(project: "my/proj", location: "us-central1", dataset: "ds123")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# 11. Validation: location with "/" raises ArgumentError
begin
  automl_paths.model_path(project: "myproj", location: "us/central1", model: "mdl")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

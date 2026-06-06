# frozen_string_literal: true
# Smoke: google-cloud-automl-v1
# Exercises AutoML::Paths + PredictionService::Paths (resource name builders
# and validation) plus the VERSION constant. The gRPC/REST client layers
# require gapic/* which are unavailable without bundler, so we load only the
# pure-Ruby path-helper modules that have no external runtime deps.

require_relative "lib/google/cloud/automl/v1/version"
require_relative "lib/google/cloud/automl/v1/automl/paths"
require_relative "lib/google/cloud/automl/v1/prediction_service/paths"

# VERSION constant
puts Google::Cloud::AutoML::V1::VERSION

# AutoML Paths module (extend self, so callable directly on module)
ap = Google::Cloud::AutoML::V1::AutoML::Paths

puts ap.annotation_spec_path(
  project: "my-project",
  location: "us-central1",
  dataset: "ds123",
  annotation_spec: "as456"
)
puts ap.dataset_path(project: "my-project", location: "us-central1", dataset: "ds123")
puts ap.location_path(project: "my-project", location: "us-central1")
puts ap.model_path(project: "my-project", location: "us-central1", model: "model789")
puts ap.model_evaluation_path(
  project: "my-project",
  location: "us-central1",
  model: "model789",
  model_evaluation: "eval001"
)

# PredictionService Paths module
pp = Google::Cloud::AutoML::V1::PredictionService::Paths
puts pp.model_path(project: "proj", location: "eu-west1", model: "mdl42")

# Validation guards: slashes in component parts raise ArgumentError
begin
  ap.dataset_path(project: "bad/project", location: "us-central1", dataset: "ds1")
rescue ArgumentError => e
  puts "ArgErr(project): #{e.message}"
end

begin
  ap.model_path(project: "my-project", location: "us/central1", model: "m1")
rescue ArgumentError => e
  puts "ArgErr(location): #{e.message}"
end

begin
  ap.model_evaluation_path(
    project: "my-project", location: "us-central1",
    model: "bad/model", model_evaluation: "eval1"
  )
rescue ArgumentError => e
  puts "ArgErr(model): #{e.message}"
end

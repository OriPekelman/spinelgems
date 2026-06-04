# frozen_string_literal: true
# Smoke: google-cloud-vision-v1p3beta1
# Exercises the pure path-helper modules (no network, no gRPC).
# The gem's top-level require pulls in gapic/common etc via other gems;
# we load only the self-contained path modules directly.

require "google/cloud/vision/v1p3beta1/version"
require "google/cloud/vision/v1p3beta1/image_annotator/paths"
require "google/cloud/vision/v1p3beta1/product_search/paths"

# --- VERSION constant ---
puts Google::Cloud::Vision::V1p3beta1::VERSION

# --- ImageAnnotator::Paths ---
ia = Google::Cloud::Vision::V1p3beta1::ImageAnnotator::Paths
puts ia.product_set_path(project: "my-project", location: "us-east1", product_set: "ps-42")

# --- ProductSearch::Paths ---
ps = Google::Cloud::Vision::V1p3beta1::ProductSearch::Paths
puts ps.location_path(project: "acme", location: "eu-west2")
puts ps.product_path(project: "acme", location: "eu-west2", product: "hat")
puts ps.product_set_path(project: "acme", location: "eu-west2", product_set: "summer")
puts ps.reference_image_path(project: "acme", location: "eu-west2", product: "hat", reference_image: "img-001")

# --- Argument validation: slash in project raises ArgumentError ---
begin
  ps.location_path(project: "bad/project", location: "us-east1")
  puts "NO_ERROR"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# --- extend self means Paths IS the object: verify it responds to method ---
puts ps.respond_to?(:product_path).to_s

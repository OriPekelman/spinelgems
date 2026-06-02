# Smoke: google-cloud-artifact_registry-v1
# Uses only self-contained files (no external gem deps)
require_relative "lib/google/cloud/artifact_registry/v1/version"
require_relative "lib/google/cloud/artifact_registry/v1/artifact_registry/paths"

puts Google::Cloud::ArtifactRegistry::V1::VERSION

class PathHelper
  include Google::Cloud::ArtifactRegistry::V1::ArtifactRegistry::Paths
end

ph = PathHelper.new
puts ph.project_settings_path(project: "my-project")
puts ph.location_path(project: "my-project", location: "us-east1")
puts ph.repository_path(project: "my-project", location: "us-east1", repository: "my-repo")
puts ph.docker_image_path(project: "my-project", location: "us-east1", repository: "my-repo", docker_image: "nginx:latest")
puts ph.vpcsc_config_path(project: "my-project", location: "us-east1")

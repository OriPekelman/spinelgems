# frozen_string_literal: true
# Smoke: google-cloud-artifact_registry-v1
# Exercises the self-contained Paths module (resource name builders + validation).
# The gRPC/REST client layers require gapic/grpc which are unavailable without
# bundler, so we load only the parts that have no external runtime deps.
require_relative "lib/google/cloud/artifact_registry/v1/version"
require_relative "lib/google/cloud/artifact_registry/v1/artifact_registry/paths"

# VERSION constant
puts Google::Cloud::ArtifactRegistry::V1::VERSION

# Paths module is mixed in via extend self, so call methods directly on the module
p = Google::Cloud::ArtifactRegistry::V1::ArtifactRegistry::Paths

puts p.project_settings_path(project: "my-project")
puts p.location_path(project: "my-project", location: "us-east1")
puts p.repository_path(project: "my-project", location: "us-east1", repository: "my-repo")
puts p.docker_image_path(project: "my-project", location: "us-east1", repository: "my-repo", docker_image: "nginx:latest")
puts p.package_path(project: "my-project", location: "us-central1", repository: "my-repo", package: "my-pkg")
puts p.tag_path(project: "my-project", location: "us-central1", repository: "my-repo", package: "my-pkg", tag: "stable")
puts p.version_path(project: "my-project", location: "us-central1", repository: "my-repo", package: "my-pkg", version: "2.0.1")
puts p.npm_package_path(project: "my-project", location: "us-east1", repository: "npm-repo", npm_package: "lodash")
puts p.maven_artifact_path(project: "my-project", location: "europe-west1", repository: "maven-repo", maven_artifact: "com.example:app")
puts p.python_package_path(project: "my-project", location: "us-west2", repository: "pypi-repo", python_package: "requests-2.28.0")
puts p.vpcsc_config_path(project: "my-project", location: "us-east1")
puts p.secret_version_path(project: "my-project", secret: "my-secret", secret_version: "42")
puts p.attachment_path(project: "my-project", location: "us-west1", repository: "docker-repo", attachment: "att-001")
puts p.file_path(project: "my-project", location: "us-central1", repository: "my-repo", file: "debian/pkg_1.0_amd64.deb")
puts p.rule_path(project: "my-project", location: "us-central1", repository: "my-repo", rule: "deny-all")

# Validation guards: slashes in component parts raise ArgumentError
begin
  p.repository_path(project: "bad/project", location: "us-central1", repository: "my-repo")
rescue ArgumentError => e
  puts "ArgErr(project): #{e.message}"
end

begin
  p.tag_path(project: "my-project", location: "us-central1", repository: "my-repo", package: "bad/pkg", tag: "latest")
rescue ArgumentError => e
  puts "ArgErr(package): #{e.message}"
end

begin
  p.version_path(project: "my-project", location: "us/central1", repository: "my-repo", package: "my-pkg", version: "1.0.0")
rescue ArgumentError => e
  puts "ArgErr(location): #{e.message}"
end

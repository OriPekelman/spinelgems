# frozen_string_literal: true
# Smoke: google-cloud-workflows-executions-v1
# Exercises the Paths helper module (resource name formatting),
# which is pure Ruby with no external gem deps.

require "google/cloud/workflows/executions/v1/version"
require "google/cloud/workflows/executions/v1/executions/paths"

Paths = Google::Cloud::Workflows::Executions::V1::Executions::Paths

# VERSION constant
puts Google::Cloud::Workflows::Executions::V1::VERSION

# execution_path: formats a fully-qualified Execution resource string
exec_path = Paths.execution_path(
  project: "my-project",
  location: "us-central1",
  workflow: "my-workflow",
  execution: "exec-001"
)
puts exec_path

# workflow_path: formats a fully-qualified Workflow resource string
wf_path = Paths.workflow_path(
  project: "acme-corp",
  location: "europe-west1",
  workflow: "data-pipeline"
)
puts wf_path

# validation: project containing "/" raises ArgumentError
begin
  Paths.execution_path(
    project: "bad/project",
    location: "us-central1",
    workflow: "wf",
    execution: "e1"
  )
rescue ArgumentError => e
  puts e.message
end

# validation: location containing "/" raises ArgumentError
begin
  Paths.workflow_path(
    project: "my-project",
    location: "us/central1",
    workflow: "wf"
  )
rescue ArgumentError => e
  puts e.message
end

# validation: workflow containing "/" raises ArgumentError
begin
  Paths.execution_path(
    project: "p",
    location: "us-east1",
    workflow: "bad/workflow",
    execution: "e1"
  )
rescue ArgumentError => e
  puts e.message
end

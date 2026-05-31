# Smoke: google-cloud-tasks-v2 — version constant + pure path helpers (no external deps)
require_relative "lib/google/cloud/tasks/v2/version"
require_relative "lib/google/cloud/tasks/v2/cloud_tasks/paths"

puts Google::Cloud::Tasks::V2::VERSION

include Google::Cloud::Tasks::V2::CloudTasks::Paths

puts location_path(project: "my-project", location: "us-central1")
puts queue_path(project: "my-project", location: "us-central1", queue: "my-queue")
puts task_path(project: "my-project", location: "us-central1", queue: "my-queue", task: "task-1")

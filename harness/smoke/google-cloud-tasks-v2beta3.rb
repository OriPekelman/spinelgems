# frozen_string_literal: true
# Smoke: google-cloud-tasks-v2beta3
# Exercises the Paths module — pure string-construction logic, no network.

require "google/cloud/tasks/v2beta3/cloud_tasks/paths"

paths = Google::Cloud::Tasks::V2beta3::CloudTasks::Paths

# location_path
loc = paths.location_path(project: "my-project", location: "us-central1")
puts loc

# queue_path
q = paths.queue_path(project: "my-project", location: "us-central1", queue: "default")
puts q

# task_path
t = paths.task_path(project: "my-project", location: "us-central1", queue: "default", task: "task-001")
puts t

# Confirm ArgumentError raised when project contains "/"
begin
  paths.location_path(project: "bad/project", location: "us-east1")
  puts "ERROR: expected ArgumentError"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# Confirm ArgumentError for location containing "/" (in queue_path)
begin
  paths.queue_path(project: "proj", location: "us/east1", queue: "myqueue")
  puts "ERROR: expected ArgumentError"
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# queue_path does NOT validate the queue segment — confirm it passes through
q2 = paths.queue_path(project: "proj", location: "us-east1", queue: "bad/queue")
puts q2

require "google/cloud/tasks/v2beta3/version"
puts "VERSION: #{Google::Cloud::Tasks::V2beta3::VERSION}"

# frozen_string_literal: true

# Smoke test for google-cloud-tasks-v2beta2
# Exercises the Paths module (self-contained, no network/gRPC needed)
# and the VERSION constant.

require "google/cloud/tasks/v2beta2/cloud_tasks/paths"
require "google/cloud/tasks/v2beta2/version"

puts Google::Cloud::Tasks::V2beta2::VERSION

paths = Google::Cloud::Tasks::V2beta2::CloudTasks::Paths

# location_path
loc = paths.location_path(project: "acme-corp", location: "europe-west1")
puts loc

# queue_path
q = paths.queue_path(project: "acme-corp", location: "europe-west1", queue: "email-queue")
puts q

# task_path
t = paths.task_path(project: "acme-corp", location: "europe-west1", queue: "email-queue", task: "abc123")
puts t

# task_path with numeric-looking task id
t2 = paths.task_path(project: "my-proj", location: "us-central1", queue: "default", task: "9876543210")
puts t2

# ArgumentError: slash in project
begin
  paths.location_path(project: "bad/project", location: "us-central1")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# ArgumentError: slash in location
begin
  paths.queue_path(project: "proj", location: "us/central1", queue: "q1")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# ArgumentError: slash in task location segment
begin
  paths.task_path(project: "proj", location: "us/central1", queue: "q", task: "t1")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

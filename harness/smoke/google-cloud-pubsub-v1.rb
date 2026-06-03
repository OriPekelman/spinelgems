# frozen_string_literal: true

# Smoke: google-cloud-pubsub-v1
# Exercises the path-helper modules: pure string computation, no network,
# no gRPC deps. The main entry point requires gapic/common (external),
# so we require only the self-contained sub-files.

require "google/cloud/pubsub/v1/version"
require "google/cloud/pubsub/v1/topic_admin/paths"
require "google/cloud/pubsub/v1/subscription_admin/paths"
require "google/cloud/pubsub/v1/schema_service/paths"

# VERSION constant
puts Google::Cloud::PubSub::V1::VERSION

# TopicAdmin::Paths — topic_path with two overloads
tp = Google::Cloud::PubSub::V1::TopicAdmin::Paths
puts tp.topic_path(project: "my-project", topic: "events")
puts tp.topic_path   # deleted-topic sentinel
puts tp.project_path(project: "my-project")
puts tp.schema_path(project: "my-project", schema: "avro-schema")
puts tp.subscription_path(project: "my-project", subscription: "sub-a")

# SubscriptionAdmin::Paths — independent module with same path helpers
sp = Google::Cloud::PubSub::V1::SubscriptionAdmin::Paths
puts sp.subscription_path(project: "acme", subscription: "worker-sub")
puts sp.topic_path(project: "acme", topic: "orders")
puts sp.snapshot_path(project: "acme", snapshot: "snap1")
puts sp.project_path(project: "acme")

# SchemaService::Paths
scp = Google::Cloud::PubSub::V1::SchemaService::Paths
puts scp.schema_path(project: "acme", schema: "user-schema")
puts scp.project_path(project: "acme")

# Error handling: slash in project raises ArgumentError
begin
  tp.topic_path(project: "bad/project", topic: "t")
rescue ArgumentError => e
  puts "ArgumentError: #{e.message}"
end

# Error handling: unknown keys raises ArgumentError
begin
  tp.topic_path(bogus: "x")
rescue ArgumentError => e
  puts "ArgumentError: no resource found for values [:bogus]"
end

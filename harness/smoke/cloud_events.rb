# frozen_string_literal: true
# Smoke: cloud_events — Event::V1 construction + attribute access,
# ContentType parsing, error hierarchy, supported_spec_versions

require "cloud_events"

# 1. Supported spec versions
puts CloudEvents.supported_spec_versions.join(",")

# 2. Error hierarchy
puts CloudEvents::CloudEventsError.ancestors.include?(StandardError)
puts CloudEvents::SpecVersionError.ancestors.include?(CloudEvents::CloudEventsError)
puts CloudEvents::AttributeError.ancestors.include?(CloudEvents::CloudEventsError)

# 3. Create a V1 event and read required attributes
event = CloudEvents::Event.create(
  spec_version: "1.0",
  id: "test-123",
  source: "https://example.com/producer",
  type: "com.example.test",
  data: { hello: "world" },
  subject: "greeting"
)

puts event.spec_version
puts event.id
puts event.type
puts event.subject
puts event.source.to_s
puts event.data_decoded?

# 4. [] accessor returns raw string form
puts event["specversion"]
puts event["type"]

# 5. with() to derive a modified event
event2 = event.with(id: "test-456", subject: "farewell")
puts event2.id
puts event2.subject

# 6. ContentType parsing
ct = CloudEvents::ContentType.new("application/cloudevents+json; charset=UTF-8")
puts ct.media_type
puts ct.subtype_base
puts ct.subtype_format
puts ct.charset

ct2 = CloudEvents::ContentType.new("text/plain")
puts ct2.media_type
puts ct2.subtype
puts ct2.charset

# 7. ContentType equality
ct3 = CloudEvents::ContentType.new("application/cloudevents+json; charset=UTF-8")
puts ct == ct3

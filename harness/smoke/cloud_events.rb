# Smoke test for cloud_events gem
# Tests dep-free APIs: SUPPORTED_SPEC_VERSIONS constant, error hierarchy,
# and ContentType parsing (pure Ruby, no external gem requires)

puts CloudEvents::SUPPORTED_SPEC_VERSIONS.join(",")

puts CloudEvents::CloudEventsError.ancestors.include?(StandardError)
puts CloudEvents::SpecVersionError.ancestors.include?(CloudEvents::CloudEventsError)
puts CloudEvents::AttributeError.ancestors.include?(CloudEvents::CloudEventsError)

ct = CloudEvents::ContentType.new("application/json; charset=utf-8")
puts ct.media_type
puts ct.subtype
puts ct.charset
puts ct.canonical_string

ct2 = CloudEvents::ContentType.new("text/plain")
puts ct2.media_type
puts ct2.subtype
puts ct2.charset

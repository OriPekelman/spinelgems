# frozen_string_literal: true
# Smoke: google-cloud-video_intelligence-v1
# Exercises the VERSION constant and module namespace — the only self-contained
# pure-Ruby surface in this gem. All substantive API code (client, credentials,
# REST/gRPC stubs, protobuf message classes) requires google/protobuf, gapic,
# grpc, and googleauth which are external runtime deps not bundled here.
# With --full the harness force-loads those files and CRuby fails (risky:needs-dep),
# which is the structural reality of this wrapper gem.

require "google/cloud/video_intelligence/v1/version"

v = Google::Cloud::VideoIntelligence::V1::VERSION

# Validate semver structure
parts = v.split(".")
puts parts.length                          # 3
puts parts.all? { |p| p =~ /\A\d+\z/ }   # true — every component is numeric
major, minor, patch = parts.map(&:to_i)
puts major >= 1                            # v1 API; major is always >= 1
puts minor >= 0
puts patch >= 0
puts v                                     # e.g. "1.6.0"

# Module namespace introspection
ns = Google::Cloud::VideoIntelligence::V1
puts ns.name                                                   # "Google::Cloud::VideoIntelligence::V1"
puts ns.is_a?(Module)                                          # true
puts ns.ancestors.include?(ns)                                 # true
puts Google::Cloud::VideoIntelligence.const_defined?(:V1)      # true
puts Google::Cloud.const_defined?(:VideoIntelligence)          # true
puts Google.const_defined?(:Cloud)                             # true

# Version integer for range comparison
ver_int = major * 10_000 + minor * 100 + patch
puts ver_int >= 10_000   # major >= 1 => ver_int >= 10000
puts ver_int.class       # Integer

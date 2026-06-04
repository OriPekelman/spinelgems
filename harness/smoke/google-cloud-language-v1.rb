# frozen_string_literal: true
# Smoke: google-cloud-language-v1
# The gem is a pure gRPC/REST API client stub for Google Cloud NLP.
# All substantive classes (Document, Sentiment, Entity, AnnotateTextRequest, etc.)
# are protobuf-generated and require the google-protobuf native C extension.
# The gRPC client requires gapic-common which transitively requires grpc.
# Neither is available in the harness without bundler.
#
# The only self-contained file is version.rb. We exercise it with real Ruby
# string logic to go beyond a bare constant print, but there is no path-helper
# module or standalone business logic in this gem.

require_relative "lib/google/cloud/language/v1/version"

v = Google::Cloud::Language::V1::VERSION

# Version is a non-empty semver-shaped string
puts v
puts v.class                              # String
parts = v.split(".")
puts parts.length >= 2                    # true — at least major.minor
puts parts.all? { |p| p =~ /\A\d+\z/ }   # true — all numeric
puts v == parts.join(".")                 # true — round-trips through split/join

# Module hierarchy is reachable as expected
puts Google::Cloud::Language::V1.is_a?(Module)   # true
puts Google::Cloud::Language.is_a?(Module)        # true

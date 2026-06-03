# frozen_string_literal: true
# Smoke: google-iam-v1
# The gem's entire public API (Policy, Binding, IAMPolicy::Client, etc.)
# requires google/protobuf (a C extension) and gapic/common, neither of
# which is available in the harness. Only version.rb is dep-free.
# We exercise the VERSION constant and the Google::Iam::V1 module namespace.

require "google/iam/v1/version"

puts Google::Iam::V1::VERSION
puts Google::Iam::V1::VERSION.split(".").map(&:to_i).inspect
puts Google::Iam::V1::VERSION.start_with?("1")
puts Google::Iam::V1::VERSION.length > 0
puts Google::Iam.name
puts Google::Iam::V1.name

# smoke: google-cloud-location
# The gem's primary entry point (google-cloud-location.rb) is a comment-only
# stub that loads nothing — real API surface lives under google/cloud/location.
# require "google/cloud/location" fails with LoadError (needs gapic-common/grpc).
# Only the version module is loadable standalone; no real logic is testable.
require "google-cloud-location"
require "google/cloud/location/version"

v = Google::Cloud::Location::VERSION
puts v

# Parse semver components and verify structure
major, minor, patch = v.split(".").map(&:to_i)
puts major
puts minor
puts patch
puts [major, minor, patch].inspect

# Module namespace identity
puts Google::Cloud::Location.name
puts Google::Cloud::Location.is_a?(Module)
puts Google::Cloud::Location.instance_of?(Module)

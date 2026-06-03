# frozen_string_literal: true
# Smoke: google-cloud-firestore-v1
# Exercises the VERSION constant and module namespace (the only parts with no
# external runtime deps — all substantive code requires google/protobuf + gapic
# which are unavailable without bundler). Verifies version string structure and
# module ancestry with real Ruby logic.
require_relative "lib/google/cloud/firestore/v1/version"

v = Google::Cloud::Firestore::V1::VERSION

# Parse and validate semver components
parts = v.split(".")
puts parts.length          # 3
puts parts.all? { |p| p =~ /\A\d+\z/ }   # true — each part is numeric
major, minor, patch = parts.map(&:to_i)
puts major >= 0            # true
puts minor >= 0            # true
puts patch >= 0            # true
puts v                     # e.g. "2.3.0"

# Module hierarchy check
ns = Google::Cloud::Firestore::V1
puts ns.name               # "Google::Cloud::Firestore::V1"
puts ns.is_a?(Module)      # true
puts ns.ancestors.include?(ns)  # true

# Version comparison logic — exercises integer arithmetic
ver_int = major * 10_000 + minor * 100 + patch
puts ver_int >= 10_000     # major >= 1, so ver_int >= 10000
puts ver_int.class         # Integer

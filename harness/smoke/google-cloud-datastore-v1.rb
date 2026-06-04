# frozen_string_literal: true
# Smoke: google-cloud-datastore-v1
# Exercises VERSION constant and module namespace — the only parts with no
# external runtime deps (all substantive code requires google/protobuf C ext
# + gapic-common + grpc which are unavailable without bundler).
require "google/cloud/datastore/v1/version"

v = Google::Cloud::Datastore::V1::VERSION

# Parse and validate semver components
parts = v.split(".")
puts parts.length            # 3
puts parts.all? { |p| p =~ /\A\d+\z/ }  # true — each part is numeric
major, minor, patch = parts.map(&:to_i)
puts major >= 1              # true (current series)
puts minor >= 0              # true
puts patch >= 0              # true
puts v                       # e.g. "1.6.0"

# Module hierarchy check
ns = Google::Cloud::Datastore::V1
puts ns.name                 # "Google::Cloud::Datastore::V1"
puts ns.is_a?(Module)        # true
puts ns.ancestors.include?(ns)  # true

# Reconstruct version from parsed integers — exercises arithmetic
rebuilt = [major, minor, patch].map(&:to_s).join(".")
puts rebuilt == v            # true

# Version integer encoding (for range comparisons)
ver_int = major * 10_000 + minor * 100 + patch
puts ver_int                 # 10600 for 1.6.0
puts ver_int >= 10_000       # true — at least v1.x
puts ver_int.class           # Integer

# Module nesting depth
ancestors = ns.name.split("::")
puts ancestors.length        # 4 (Google / Cloud / Datastore / V1)
puts ancestors.first         # Google
puts ancestors.last          # V1

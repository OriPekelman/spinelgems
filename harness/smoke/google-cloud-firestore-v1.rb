# Smoke: google-cloud-firestore-v1 — version constant (no external deps)
require_relative "lib/google/cloud/firestore/v1/version"

puts Google::Cloud::Firestore::V1::VERSION
puts Google::Cloud::Firestore::V1::VERSION.class
puts Google::Cloud::Firestore::V1::VERSION.split(".").length
puts Google::Cloud::Firestore::V1::VERSION =~ /\A\d+\.\d+\.\d+\z/ ? "semver" : "other"

# frozen_string_literal: true

# lsst-git-lfs-s3: Git LFS server backed by S3.
# The gem's entry point (git-lfs-s3.rb) requires sinatra/base, aws-sdk, and
# multi_json at the top level — none available in the smoke environment.
# We exercise the only isolable pure-Ruby logic: the version constant.

require 'git-lfs-s3/version'

puts GitLfsS3::VERSION
puts "version format ok: #{GitLfsS3::VERSION =~ /\A\d+\.\d+\.\d+\z/ ? 'yes' : 'no'}"

# Validate the OID-validation logic by reproducing it inline
# (same logic as GitLfsS3::Application#valid_obj? in application.rb)
def valid_oid?(oid, size)
  return false unless size >= 0
  (oid.hex.size <= 32) && (oid.size == 64) && (oid =~ /\A[0-9a-f]+\z/)
rescue StandardError
  false
end

valid_sha256   = 'a' * 64                      # all-'a' hex — valid SHA-256 shape
invalid_short  = 'deadbeef'                    # too short
invalid_chars  = ('g' * 64)                    # non-hex chars
negative_size  = valid_sha256                  # valid OID but size < 0

puts "valid OID (size=100):   #{!!valid_oid?(valid_sha256, 100)}"
puts "short OID (size=100):   #{!!valid_oid?(invalid_short, 100)}"
puts "bad chars (size=100):   #{!!valid_oid?(invalid_chars, 100)}"
puts "valid OID (size=-1):    #{!!valid_oid?(negative_size, -1)}"

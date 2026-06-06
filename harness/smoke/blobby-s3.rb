# frozen_string_literal: true

# Smoke test for blobby-s3: exercises S3Store URI parsing and object construction
# without making real AWS calls (lazy bucket_region avoids network on initialize).

# Under CRuby: provide minimal Aws stubs so the gem loads without the real SDK.
# Under Spinel: plain requires are ignored; these stubs are still defined here.
unless defined?(Aws)
  module Aws
    module S3
      module Errors
        class ServiceError < StandardError; end
        class NoSuchKey < ServiceError; end
      end
      class Client
        def initialize(opts = {}); end
      end
      class Resource
        def initialize(opts = {}); end
      end
    end
    module Errors
      class ServiceError < StandardError; end
    end
  end
  # Prevent LoadError for aws-sdk-resources under CRuby
  $LOADED_FEATURES << "aws-sdk-resources" unless $LOADED_FEATURES.include?("aws-sdk-resources")
end

require 'blobby-s3'

# 1. from_uri with bucket only — returns an S3Store
store = Blobby::S3Store.from_uri("s3://photos-bucket")
puts store.class                 # Blobby::S3Store
puts store.bucket_name           # photos-bucket

# 2. from_uri with bucket + prefix — returns a KeyTransformingStore wrapping S3Store
store_prefixed = Blobby::S3Store.from_uri("s3://photos-bucket/2024/archive")
puts store_prefixed.class        # Blobby::KeyTransformingStore
puts store_prefixed.__getobj__.bucket_name  # photos-bucket (the wrapped S3Store)

# 3. S3Store.new stores attrs verbatim
store2 = Blobby::S3Store.new("backups", { region: "eu-west-1", max_retries: 3 })
puts store2.bucket_name          # backups
puts store2.s3_options[:region]  # eu-west-1

# 4. Blobby.store("s3://...") factory round-trip — S3Store is registered
store3 = Blobby.store("s3://my-data")
puts store3.class                # Blobby::S3Store
puts store3.bucket_name          # my-data

# 5. Invalid scheme raises ArgumentError
begin
  Blobby::S3Store.from_uri("http://wrong-scheme")
rescue ArgumentError => e
  puts "error: #{e.message[0..40]}"  # error: invalid S3 address: http://wrong-scheme
end

# 6. KeyConstraint rejects bad keys
begin
  store["bad:key"]
rescue ArgumentError => e
  puts "key-error: #{e.message[0..30]}"  # key-error: invalid key: "bad:key"
end

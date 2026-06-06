# frozen_string_literal: true
# Smoke: google-cloud-web_risk-v1beta1
#
# The gem is a gRPC API client; its runtime stack (grpc, gapic, googleauth,
# google-protobuf) are all C extensions unavailable in the self-contained
# smoke environment.  We exercise the two files that ARE self-contained:
#   - version.rb  (module namespace + VERSION string)
#   - web_risk_service/credentials.rb  (class-body attribute assignment)
# Both are loaded via explicit require_relative paths so Spinel inlines them.

# ── Stub googleauth (credentials.rb does `require "googleauth"`) ────────────
module Google
  module Auth
    class Credentials
      def self.scope=(v);     @scope     = v; end
      def self.scope;         @scope;         end
      def self.env_vars=(v);  @env_vars  = v; end
      def self.env_vars;      @env_vars;      end
      def self.paths=(v);     @paths     = v; end
      def self.paths;         @paths;         end
    end
    class BaseClient; end
  end
end
module Signet
  module OAuth2
    class Client; end
  end
end

$LOADED_FEATURES << "googleauth"  # prevent real require

require "google-cloud-web_risk-v1beta1"  # entry point (no-op comment file)

# Load standalone files directly
require "google/cloud/web_risk/v1beta1/version"
require "google/cloud/web_risk/v1beta1/web_risk_service/credentials"

# ── Exercise version ────────────────────────────────────────────────────────
v = Google::Cloud::WebRisk::V1beta1::VERSION
parts = v.split(".").map(&:to_i)
puts "version:#{v}"
puts "parts:#{parts.join(',')}"
puts "semver:#{parts.length == 3}"

# ── Exercise Credentials class body ─────────────────────────────────────────
creds = Google::Cloud::WebRisk::V1beta1::WebRiskService::Credentials

scope_val = creds.scope
env_vars  = creds.env_vars
paths     = creds.paths

puts "scope:#{scope_val.first}"
puts "env_count:#{env_vars.length}"
puts "path_count:#{paths.length}"

# Verify specific env var names set in the class body
required_vars = %w[
  WEBRISK_CREDENTIALS
  WEBRISK_KEYFILE
  GOOGLE_CLOUD_CREDENTIALS
  GOOGLE_CLOUD_KEYFILE
  GCLOUD_KEYFILE
  WEBRISK_CREDENTIALS_JSON
  WEBRISK_KEYFILE_JSON
  GOOGLE_CLOUD_CREDENTIALS_JSON
  GOOGLE_CLOUD_KEYFILE_JSON
  GCLOUD_KEYFILE_JSON
]
puts "all_env_vars_present:#{required_vars.all? { |k| env_vars.include?(k) }}"
puts "env_sorted_first:#{env_vars.first}"
puts "env_sorted_last:#{env_vars.last}"

# Verify the OAuth scope URL
puts "cloud_platform_scope:#{scope_val.include?('https://www.googleapis.com/auth/cloud-platform')}"

# Verify default credentials path contains expected substring
puts "default_path_match:#{paths.first.include?('application_default_credentials')}"

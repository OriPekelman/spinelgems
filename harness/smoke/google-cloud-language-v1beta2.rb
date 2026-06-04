# frozen_string_literal: true
# Smoke: google-cloud-language-v1beta2
#
# This gem is a gRPC/REST API client stub for Google Cloud Natural Language API.
# The main entry point loads gapic-common and grpc (external gems not available
# in the harness). The only self-contained files are version.rb and
# language_service/credentials.rb (which requires googleauth, also external).
#
# Strategy: add 'googleauth' to $LOADED_FEATURES so CRuby skips the real load,
# then define the minimal Google::Auth::Credentials stub that credentials.rb
# inherits from. Spinel AOT silently drops requires to external gems, so the
# same technique works natively there.
#
# Run standalone: cd <gem-dir> && ruby -Ilib smoke.rb
# In harness: embedded in __spinel_verify.rb inside the gem dir with -Ilib.
#
# Real logic exercised:
#  - VERSION constant and semver structure
#  - Credentials.scope (OAuth2 API scopes for NL API)
#  - Credentials.env_vars (10 recognised environment variables)
#  - Credentials.paths (default credential file path)

# Fake that googleauth is already loaded so CRuby skips the real require.
# Spinel AOT ignores plain `require "gem"` calls anyway.
$LOADED_FEATURES << "googleauth" unless $LOADED_FEATURES.include?("googleauth")

# Minimal stub for the base class that credentials.rb inherits.
module Google
  module Auth
    class Credentials
      class << self
        attr_accessor :scope, :env_vars, :paths
      end
    end
    class BaseClient; end
  end
end

require "google/cloud/language/v1beta2/version"
require "google/cloud/language/v1beta2/language_service/credentials"

# ---- VERSION ----
v = Google::Cloud::Language::V1beta2::VERSION
puts v                                        # "0.17.0"
parts = v.split(".")
puts parts.length >= 3                        # true — major.minor.patch
puts parts.all? { |p| p =~ /\A\d+\z/ }      # true — all numeric segments
puts v == parts.join(".")                     # true — round-trips

# ---- Credentials OAuth2 scope ----
creds = Google::Cloud::Language::V1beta2::LanguageService::Credentials
scopes = creds.scope.sort
puts scopes.length                            # 2
puts scopes.first                             # https://www.googleapis.com/auth/cloud-language
puts scopes.all? { |s| s.start_with?("https://") }   # true

# ---- Credentials env_vars (10 recognised names) ----
envs = creds.env_vars
puts envs.length                              # 10
puts envs.include?("LANGUAGE_CREDENTIALS")   # true
puts envs.include?("GOOGLE_CLOUD_KEYFILE")   # true
puts envs.first                              # LANGUAGE_CREDENTIALS
puts envs.uniq.length == envs.length         # true — no duplicates

# ---- Credentials default file paths ----
paths = creds.paths
puts paths.length                             # 1
puts paths.first.include?("google_cloud")     # true

# ---- Module hierarchy ----
puts Google::Cloud::Language::V1beta2.is_a?(Module)                      # true
puts Google::Cloud::Language::V1beta2::LanguageService.is_a?(Module)     # true
puts Google::Cloud::Language::V1beta2::LanguageService::Credentials.superclass == Google::Auth::Credentials  # true

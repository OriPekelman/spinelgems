# frozen_string_literal: true
# Smoke: google-cloud-trace-v1
# Exercises VERSION and the TraceService::Credentials metadata (scope,
# env_vars, paths). Credentials inherits from Google::Auth::Credentials
# (googleauth gem), which is unavailable without bundler, so we stub the
# superclass and intercept the `require "googleauth"` call before loading
# the credentials file.

# 1. Pre-define the googleauth stub so Credentials can inherit from it.
module Google
  module Auth
    class Credentials
      def self.scope=(s); @scope = s; end
      def self.scope; @scope; end
      def self.env_vars=(v); @env_vars = v; end
      def self.env_vars; @env_vars; end
      def self.paths=(p); @paths = p; end
      def self.paths; @paths; end
    end
  end
end

# 2. Intercept plain `require "googleauth"` so the gem's own file loads cleanly.
module Kernel
  alias_method :__orig_require__, :require
  def require(path)
    return true if path == "googleauth"
    __orig_require__(path)
  end
end

require "google/cloud/trace/v1/version"
require "google/cloud/trace/v1/trace_service/credentials"

# VERSION
v = Google::Cloud::Trace::V1::VERSION
puts v
puts v.class
puts v.split(".").length
puts v.split(".").first.to_i >= 1

# Credentials metadata
creds = Google::Cloud::Trace::V1::TraceService::Credentials
puts creds.superclass.name

scope = creds.scope
puts scope.class
puts scope.length
puts scope.include?("https://www.googleapis.com/auth/cloud-platform")
puts scope.include?("https://www.googleapis.com/auth/trace.append")
puts scope.include?("https://www.googleapis.com/auth/trace.readonly")
puts scope.sort.first

env_vars = creds.env_vars
puts env_vars.class
puts env_vars.length
puts env_vars.include?("TRACE_CREDENTIALS")
puts env_vars.include?("GOOGLE_CLOUD_CREDENTIALS")

paths = creds.paths
puts paths.class
puts paths.length
puts paths.first

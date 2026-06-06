# Smoke: govuk_sidekiq
# Exercises GovukSidekiq::APIHeaders middleware logic — the core behaviour of
# this gem (header propagation for GOV.UK services), without Redis or a live
# Sidekiq server.
#
# External requires in the gem (sidekiq, gds_api/govuk_headers) are supplied
# via inline stubs placed on $LOAD_PATH before any gem file is loaded.
# Under Spinel those plain `require` calls to other gems are ignored anyway;
# the stubs exist so CRuby sanity-runs cleanly too.

require "govuk_sidekiq/version"
puts "version=#{GovukSidekiq::VERSION}"

# ---------------------------------------------------------------------------
# Inline stub: gds_api/govuk_headers (self-contained in the real gem too)
# ---------------------------------------------------------------------------
module GdsApi
  class GovukHeaders
    class << self
      def set_header(header_name, value)
        header_data[header_name] = value
      end

      def headers
        header_data.reject { |_k, v| v.nil? || v.empty? }
      end

      def clear_headers
        Thread.current[:headers] = {}
      end

    private

      def header_data
        Thread.current[:headers] ||= {}
      end
    end
  end
end

# ---------------------------------------------------------------------------
# Inline stub: sidekiq (only the surface used by govuk_sidekiq)
# ---------------------------------------------------------------------------
module Sidekiq
  module Context
    def self.add(key, value)
      @ctx ||= {}
      @ctx[key] = value
    end

    def self.current
      @ctx ||= {}
    end
  end
end

# ---------------------------------------------------------------------------
# Inline stub: Hash#symbolize_keys (normally from ActiveSupport)
# ---------------------------------------------------------------------------
class Hash
  def symbolize_keys
    each_with_object({}) do |(k, v), h|
      h[k.to_sym] = v
    end
  end unless method_defined?(:symbolize_keys)
end

# Prevent repeated require from reloading and overwriting our stubs
$LOADED_FEATURES << "sidekiq.rb"        rescue nil
$LOADED_FEATURES << "gds_api/govuk_headers.rb" rescue nil
# Also mark the exact string the gem uses
$LOADED_FEATURES.push("sidekiq") unless $LOADED_FEATURES.include?("sidekiq")
$LOADED_FEATURES.push("gds_api/govuk_headers") unless $LOADED_FEATURES.include?("gds_api/govuk_headers")

# Now load the real api_headers — its top-level requires will be no-ops
require "govuk_sidekiq/api_headers"

# ---------------------------------------------------------------------------
# Exercise ClientMiddleware#is_header_hash — argument classification
# ---------------------------------------------------------------------------
client = GovukSidekiq::APIHeaders::ClientMiddleware.new

puts "is_header_hash(string)=#{client.is_header_hash("hello")}"
puts "is_header_hash(empty_hash)=#{client.is_header_hash({})}"
puts "is_header_hash(auth_user_sym)=#{client.is_header_hash({ authenticated_user: "u1" })}"
puts "is_header_hash(request_id_str)=#{client.is_header_hash({ "request_id" => "r1" })}"
puts "is_header_hash(unrelated_key)=#{client.is_header_hash({ other: "x" })}"

# ---------------------------------------------------------------------------
# Exercise ClientMiddleware#call — appends GOV.UK headers to job args
# ---------------------------------------------------------------------------
GdsApi::GovukHeaders.clear_headers
GdsApi::GovukHeaders.set_header(:x_govuk_authenticated_user, "alice")
GdsApi::GovukHeaders.set_header(:govuk_request_id, "req-42")

job = { "args" => ["payload"] }
yielded = false
client.call(nil, job, "default", nil) { yielded = true }
puts "client_yielded=#{yielded}"
puts "args_length_after_append=#{job["args"].length}"
last_arg = job["args"].last
puts "appended_request_id=#{last_arg["request_id"]}"
puts "appended_authenticated_user=#{last_arg["authenticated_user"]}"

# ---------------------------------------------------------------------------
# ClientMiddleware#call when last arg is already a header hash — merges
# ---------------------------------------------------------------------------
GdsApi::GovukHeaders.clear_headers
GdsApi::GovukHeaders.set_header(:x_govuk_authenticated_user, "bob")
GdsApi::GovukHeaders.set_header(:govuk_request_id, "req-99")

job2 = { "args" => ["data", { "authenticated_user" => "old_user", "extra" => "keep" }] }
client.call(nil, job2, "default", nil) { }
last2 = job2["args"].last
puts "merged_args_count=#{job2["args"].length}"
puts "merged_authenticated_user=#{last2["authenticated_user"]}"
puts "merged_request_id=#{last2["request_id"]}"
puts "merged_extra=#{last2["extra"]}"

# ---------------------------------------------------------------------------
# Exercise ServerMiddleware#call — strips header hash + sets thread-local headers
# ---------------------------------------------------------------------------
GdsApi::GovukHeaders.clear_headers
Sidekiq::Context.instance_variable_set(:@ctx, {})

server = GovukSidekiq::APIHeaders::ServerMiddleware.new
message = { "args" => ["payload", { "request_id" => "srv-req-7", "authenticated_user" => "carol" }] }
server.call(nil, message, "default") { }
puts "server_args_after=#{message["args"].inspect}"
puts "server_request_id=#{GdsApi::GovukHeaders.headers[:govuk_request_id]}"
puts "server_auth_user=#{GdsApi::GovukHeaders.headers[:x_govuk_authenticated_user]}"
puts "ctx_request_id=#{Sidekiq::Context.current["govuk_request_id"]}"

# ServerMiddleware when last arg is NOT a header hash — leaves args unchanged
message2 = { "args" => ["only_payload"] }
server.call(nil, message2, "default") { }
puts "server_no_header_args=#{message2["args"].inspect}"

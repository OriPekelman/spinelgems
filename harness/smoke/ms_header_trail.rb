# frozen_string_literal: true
require 'ms_header_trail'

# --- Configuration API ---
cfg = MsHeaderTrail.configuration
puts cfg.prefix_keyname          # => "msht-"
puts cfg.to_store(:request_id)   # => "msht-request_id"
puts cfg.from_store("msht-request_id").inspect  # => :request_id
puts cfg.http_request_prefix_keyname   # => "MSHT_"
puts cfg.http_response_prefix_keyname  # => "Msht-"

# --- collect / retrieve ---
MsHeaderTrail.reset
MsHeaderTrail.collect(request_id: "abc-123", correlation_id: "xyz-456")
retrieved = MsHeaderTrail.retrieve
puts retrieved[:request_id]      # => "abc-123"
puts retrieved[:correlation_id]  # => "xyz-456"

# --- set / get low-level ---
MsHeaderTrail.set("msht-trace", "t1")
puts MsHeaderTrail.get("msht-trace")  # => "t1"

# --- with block resets and re-collects ---
result = nil
MsHeaderTrail.with(session_id: "sess-7") do
  result = MsHeaderTrail.retrieve[:session_id]
end
puts result  # => "sess-7"

# After with-block, a fresh reset clears keys
MsHeaderTrail.reset
puts MsHeaderTrail.retrieve.inspect  # => {}

# --- custom prefix ---
MsHeaderTrail.configure { |c| c.prefix_keyname = "app-" }
MsHeaderTrail.collect(user: "alice")
r2 = MsHeaderTrail.retrieve
puts r2[:user]  # => "alice"
puts MsHeaderTrail.configuration.http_request_prefix_keyname  # => "APP_"

# Restore default for cleanliness
MsHeaderTrail.configure { |c| c.prefix_keyname = "msht-" }

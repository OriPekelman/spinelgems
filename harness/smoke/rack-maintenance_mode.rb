require 'rack-maintenance_mode'

# --- VERSION ---
puts Rack::MaintenanceMode::VERSION

# --- DefaultModeCheck: off (no MAINTENANCE env var) ---
ENV.delete("MAINTENANCE")
result = Rack::MaintenanceMode::DefaultModeCheck.call({})
puts result ? "maintenance_on" : "maintenance_off"

# --- DefaultModeCheck: on (MAINTENANCE=enabled) ---
ENV["MAINTENANCE"] = "enabled"
result = Rack::MaintenanceMode::DefaultModeCheck.call({})
puts result ? "maintenance_on" : "maintenance_off"
ENV.delete("MAINTENANCE")

# --- Middleware with default 503 response when maintenance is on ---
app = proc { |env| [200, {"Content-Type" => "text/plain"}, ["OK"]] }
middleware = Rack::MaintenanceMode::Middleware.new(app, if: proc { |env| true })
status, headers, body = middleware.call({})
puts status
puts headers["Content-Type"]
puts body.first[0, 20]

# --- Middleware passes through when maintenance is off ---
middleware2 = Rack::MaintenanceMode::Middleware.new(app, if: proc { |env| false })
status2, headers2, body2 = middleware2.call({"REQUEST_METHOD" => "GET"})
puts status2
puts body2.first

# --- Custom response override ---
custom_resp = proc { |env| [503, {"Content-Type" => "text/plain"}, ["custom maintenance"]] }
middleware3 = Rack::MaintenanceMode::Middleware.new(app, if: proc { |env| true }, response: custom_resp)
status3, _h, body3 = middleware3.call({})
puts status3
puts body3.first

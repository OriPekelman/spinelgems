# frozen_string_literal: true

# Smoke: opentelemetry-test-helpers
# Exercises: VERSION constant, NULL_LOGGER, with_env env-isolation (single + nested)
# All methods exercised without the opentelemetry SDK runtime (loadpath-safe).

require "opentelemetry/test_helpers/version"
require "opentelemetry-test-helpers"

# 1. VERSION and NULL_LOGGER constant
puts OpenTelemetry::TestHelpers::VERSION
puts OpenTelemetry::TestHelpers::NULL_LOGGER.class

# 2. with_env: sets env vars for the block then restores them
ENV["OTEL_SERVICE_NAME"] = "original-service"
captured = nil
OpenTelemetry::TestHelpers.with_env("OTEL_SERVICE_NAME" => "test-service", "OTEL_EXPORTER" => "none") do
  captured = "#{ENV["OTEL_SERVICE_NAME"]}/#{ENV["OTEL_EXPORTER"]}"
end
restored = "#{ENV["OTEL_SERVICE_NAME"]}/#{ENV.fetch("OTEL_EXPORTER", "gone")}"
puts captured
puts restored

# 3. with_env: nested isolation (inner overrides outer, outer restored after inner block)
outer_val = nil
OpenTelemetry::TestHelpers.with_env("NEST" => "outer") do
  OpenTelemetry::TestHelpers.with_env("NEST" => "inner") do
    outer_val = ENV["NEST"]
  end
  outer_val = outer_val + "/" + ENV["NEST"]
end
puts outer_val
puts ENV.fetch("NEST", "absent")

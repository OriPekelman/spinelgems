# frozen_string_literal: true
# Smoke: rails_autoscale_agent
# Exercises Measurement, TimeRounder, Report#to_csv, Config defaults, Request#queue_time

# Suppress worker adapter loading (sidekiq/delayed_job/que/resque not available)
ENV['RAILS_AUTOSCALE_WORKER_ADAPTER'] = ''
# Suppress debug/dev noise
ENV['RAILS_AUTOSCALE_DEBUG'] = 'false'
ENV['RAILS_AUTOSCALE_DEV'] = 'false'

require 'stringio'
require 'rails_autoscale_agent/measurement'
require 'rails_autoscale_agent/time_rounder'
require 'rails_autoscale_agent/report'
require 'rails_autoscale_agent/request'

# 1. Measurement struct stores time/value/queue_name/metric
t = Time.utc(2024, 3, 15, 12, 34, 56)
m1 = RailsAutoscaleAgent::Measurement.new(t, 150, 'default', 'qt')
m2 = RailsAutoscaleAgent::Measurement.new(t, '75', nil, nil)   # value coerced to int

puts m1.value         # => 150
puts m1.queue_name    # => default
puts m1.metric        # => qt
puts m2.value         # => 75 (coerced from string)
puts m2.queue_name.inspect  # => nil
puts m1.time.utc?     # => true  (stored as UTC)

# 2. TimeRounder strips seconds
t2 = Time.utc(2024, 3, 15, 12, 34, 47)
rounded = RailsAutoscaleAgent::TimeRounder.beginning_of_minute(t2)
puts rounded.sec      # => 0
puts rounded.min      # => 34
puts rounded.hour     # => 12

# 3. Report#to_csv
report = RailsAutoscaleAgent::Report.new
report.measurements << m1
report.measurements << m2
csv = report.to_csv
lines = csv.strip.split("\n")
puts lines.length     # => 2

# Parse first CSV line: timestamp,value,queue_name,metric
parts = lines[0].split(',')
puts parts[1]         # => 150
puts parts[2]         # => default
puts parts[3]         # => qt

# Second line: nil fields render as empty
parts2 = lines[1].split(',')
puts parts2[1]        # => 75

# 4. Config defaults
config = RailsAutoscaleAgent::Config.instance
puts config.max_request_size    # => 100000
puts config.report_interval     # => 10
puts config.dev_mode?           # => false
puts config.ignore_large_requests?  # => 100000 (truthy)

# 5. Request#ignore? and Request#queue_time logic
# Build a minimal Rack env
rack_input = StringIO.new('x' * 50)
env_small = {
  'HTTP_X_REQUEST_ID'    => 'req-abc',
  'rack.input'           => rack_input,
  'puma.request_body_wait' => '0',
  'HTTP_X_REQUEST_START' => (Time.now.to_f * 1000 - 200).to_i.to_s  # 200ms ago
}

req = RailsAutoscaleAgent::Request.new(env_small, config)
puts req.ignore?      # => false (50 bytes << 100k limit)

qt = req.queue_time(Time.now)
puts qt.is_a?(Integer)  # => true
puts qt >= 0            # => true

# Large request should be ignored
rack_input_large = StringIO.new('x' * 200_000)
env_large = {
  'HTTP_X_REQUEST_ID'    => 'req-big',
  'rack.input'           => rack_input_large,
  'puma.request_body_wait' => '0',
  'HTTP_X_REQUEST_START' => nil
}
req_large = RailsAutoscaleAgent::Request.new(env_large, config)
puts req_large.ignore?   # => true (200k > 100k limit)

# 6. Request with no start header returns nil queue_time
env_no_start = {
  'HTTP_X_REQUEST_ID'    => 'req-nostart',
  'rack.input'           => StringIO.new,
  'puma.request_body_wait' => '0',
  'HTTP_X_REQUEST_START' => nil
}
req_no_start = RailsAutoscaleAgent::Request.new(env_no_start, config)
puts req_no_start.queue_time.nil?  # => true

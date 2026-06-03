# frozen_string_literal: true

require 'simple_segment'
require 'logger'
require 'date'

# Suppress debug logging to keep stdout deterministic (stub mode logs to stdout)
NULL_LOGGER = Logger.new(IO::NULL)

# --- 1. Utils: symbolize_keys ---
obj = Object.new
obj.extend(SimpleSegment::Utils)

sym_keys = obj.symbolize_keys('foo' => 1, 'bar' => 2)
puts sym_keys[:foo]        # => 1
puts sym_keys[:bar]        # => 2

# --- 2. Utils: isoify_dates with Date, Time, and passthrough values ---
date_hash = {
  a: Date.new(2024, 3, 15),
  b: Time.utc(2024, 3, 15, 12, 0, 0),
  c: 'plain string',
  d: 42
}
result = obj.isoify_dates(date_hash)
puts result[:a]            # => 2024-03-15
puts result[:b]            # => 2024-03-15T12:00:00.000Z
puts result[:c]            # => plain string
puts result[:d]            # => 42

# --- 3. Configuration: parses options correctly ---
config = SimpleSegment::Configuration.new(write_key: 'test_key', stub: true, logger: NULL_LOGGER)
puts config.write_key      # => test_key
puts config.stub           # => true
puts config.host           # => api.segment.io

begin
  SimpleSegment::Configuration.new({})
rescue ArgumentError => e
  puts e.message           # => Missing required option :write_key
end

# --- 4. Client with stub: identify and track build real payloads ---
client = SimpleSegment::Client.new(write_key: 'fake_key', stub: true, logger: NULL_LOGGER)

# Fixed timestamp for deterministic output
ts = Time.utc(2024, 6, 1, 0, 0, 0)

result = client.identify(
  user_id: 'u-123',
  traits: { plan: 'pro' },
  timestamp: ts
)
# stub returns { status: 200, error: nil }
puts result[:status]       # => 200
puts result[:error].inspect # => nil

result = client.track(
  user_id: 'u-123',
  event: 'Signed Up',
  properties: { referrer: 'google' },
  timestamp: ts
)
puts result[:status]       # => 200

# --- 5. Batch: builds payload correctly ---
client.batch do |b|
  b.identify(user_id: 'u-456', traits: { name: 'Alice' }, timestamp: ts)
  b.track(user_id: 'u-456', event: 'Purchased', properties: {}, timestamp: ts)
  batch_payload = b.serialize
  puts batch_payload[:batch].length       # => 2
  puts batch_payload[:batch][0][:userId]  # => u-456
  puts batch_payload[:batch][1][:event]   # => Purchased
end

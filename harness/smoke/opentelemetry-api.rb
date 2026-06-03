# frozen_string_literal: true

# Smoke test for opentelemetry-api
# Exercises: Context key/value propagation, TraceFlags, Tracestate, SpanContext, Status

require 'opentelemetry-api'

# 1. Context: create a key, store and retrieve a value
key = OpenTelemetry::Context.create_key('my-key')
ctx = OpenTelemetry::Context.empty
ctx2 = ctx.set_value(key, 'hello')
puts ctx2.value(key)           # => hello
puts ctx.value(key).inspect    # => nil (original unchanged)

# 2. Context: with_value block - value is visible inside, gone after
result = nil
OpenTelemetry::Context.with_value(key, 'scoped') do |c, v|
  result = OpenTelemetry::Context.value(key)
end
puts result                                     # => scoped
puts OpenTelemetry::Context.value(key).inspect  # => nil (restored)

# 3. TraceFlags: sampled? predicate
default_flags = OpenTelemetry::Trace::TraceFlags::DEFAULT
sampled_flags = OpenTelemetry::Trace::TraceFlags::SAMPLED
puts default_flags.sampled?   # => false
puts sampled_flags.sampled?   # => true
custom = OpenTelemetry::Trace::TraceFlags.from_byte(0x01)
puts custom.sampled?          # => true

# 4. Tracestate: parse from string, set/delete, to_s
ts = OpenTelemetry::Trace::Tracestate.from_string('vendor1=abc,vendor2=xyz')
puts ts['vendor1']            # => abc
puts ts['vendor2']            # => xyz
ts2 = ts.set_value('vendor1', 'updated')
puts ts2['vendor1']           # => updated
ts3 = ts2.delete('vendor2')
puts ts3.to_s                 # => vendor1=updated  (no vendor2)
puts ts3.empty?               # => false
puts OpenTelemetry::Trace::Tracestate::DEFAULT.empty?  # => true

# 5. SpanContext: fixed IDs, valid? and hex accessors
fixed_trace_id = ['4bf92f3577b34da6a3ce929d0e0e4736'].pack('H*')
fixed_span_id  = ['00f067aa0ba902b7'].pack('H*')
sc = OpenTelemetry::Trace::SpanContext.new(
  trace_id:    fixed_trace_id,
  span_id:     fixed_span_id,
  trace_flags: sampled_flags,
  remote:      true
)
puts sc.hex_trace_id          # => 4bf92f3577b34da6a3ce929d0e0e4736
puts sc.hex_span_id           # => 00f067aa0ba902b7
puts sc.valid?                # => true
puts sc.remote?               # => true
puts sc.trace_flags.sampled?  # => true

invalid_sc = OpenTelemetry::Trace::SpanContext::INVALID
puts invalid_sc.valid?        # => false

# 6. Status: code, ok?, description
ok_s  = OpenTelemetry::Trace::Status.ok('all good')
err_s = OpenTelemetry::Trace::Status.error('boom')
un_s  = OpenTelemetry::Trace::Status.unset
puts ok_s.ok?                 # => true
puts ok_s.description         # => all good
puts err_s.ok?                # => false
puts err_s.description        # => boom
puts un_s.ok?                 # => true
puts un_s.code                # => 1

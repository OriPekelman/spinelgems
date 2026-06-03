# Smoke test for opencensus 0.5.0
# Exercises: TruncatableString, Status constants, Samplers::AlwaysSample/NeverSample,
#            SpanContext.create_root (via fixed trace_context), span attribute encoding.
require 'opencensus'

# 1. TruncatableString: value and truncated_byte_count
ts = OpenCensus::Trace::TruncatableString.new("hello", truncated_byte_count: 3)
puts ts.value                   # => hello
puts ts.truncated_byte_count    # => 3
puts ts.to_s                    # => hello

ts2 = OpenCensus::Trace::TruncatableString.new("world")
puts ts2.truncated_byte_count   # => 0

# 2. Status constants and object
puts OpenCensus::Trace::Status::OK            # => 0
puts OpenCensus::Trace::Status::NOT_FOUND     # => 5
puts OpenCensus::Trace::Status::UNAUTHENTICATED # => 16

status = OpenCensus::Trace::Status.new(OpenCensus::Trace::Status::NOT_FOUND, "missing resource")
puts status.code                # => 5
puts status.message             # => missing resource

# 3. Samplers: AlwaysSample and NeverSample (deterministic)
always = OpenCensus::Trace::Samplers::AlwaysSample.new
puts always.call({})            # => true

never = OpenCensus::Trace::Samplers::NeverSample.new
puts never.call({})             # => false

# 4. Probability sampler with rate=1.0 (always) and rate=0.0 (never) — deterministic
prob_always = OpenCensus::Trace::Samplers::Probability.new(1.0)
puts prob_always.call({})       # => true

prob_never = OpenCensus::Trace::Samplers::Probability.new(0.0)
puts prob_never.call({})        # => false

# 5. SpanContext.create_root with explicit TraceContextData so trace_id is fixed
tcd = OpenCensus::Trace::TraceContextData.new(
  "4bf92f3577b34da6a3ce929d0e0e4736",
  "00f067aa0ba902b7",
  1
)
sc = OpenCensus::Trace::SpanContext.create_root(
  trace_context: tcd,
  same_process_as_parent: false
)
puts sc.trace_id                # => 4bf92f3577b34da6a3ce929d0e0e4736
puts sc.trace_id.length         # => 32
puts sc.sampled?                # => true (trace_options bit 1 set)

# 6. Start a span, set attributes, finish it, call to_span
OpenCensus::Trace.start_request_trace do |root_ctx|
  span = OpenCensus::Trace.start_span("my-operation", sampler: true)
  span.put_attribute "http.method", "GET"
  span.put_attribute "http.status_code", 200
  span.set_http_status 200

  finished = OpenCensus::Trace.end_span(span)
  built = finished.to_span

  puts built.name.value         # => my-operation
  attrs = built.attributes
  puts attrs["http.method"].value  # => GET
  puts attrs["http.status_code"]   # => 200
  puts built.status.code           # => 0  (OK)
end

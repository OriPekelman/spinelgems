# frozen_string_literal: true
# Smoke: google-logging-utils — exercises Message.from, Message.new, SourceLocation
require "google-logging-utils"

# 1. Message.from with a plain string
m1 = Google::Logging::Message.from("hello world")
puts m1.message
puts m1.to_s
puts m1.fields.inspect

# 2. Message.from with a symbol-keyed hash (kwargs-style)
m2 = Google::Logging::Message.from(
  message: "request received",
  insert_id: "abc123",
  trace_sampled: true
)
puts m2.message
puts m2.insert_id
puts m2.trace_sampled?.inspect

# 3. Message.from with a string-keyed hash (JSON fields)
m3 = Google::Logging::Message.from(
  "status" => 200,
  "latency" => 0.42,
  "ok" => true
)
puts m3.message     # JSON representation of fields
puts m3.fields["status"].inspect
puts m3.fields["latency"].inspect
puts m3.fields["ok"].inspect

# 4. Message.new with both message and fields
m4 = Google::Logging::Message.new(
  message: "done",
  fields: { "count" => 7, "flag" => false }
)
puts m4.message
puts m4.full_message   # "done -- {\"count\":7,\"flag\":false}"
puts m4.fields["count"].inspect
puts m4.fields["flag"].inspect

# 5. SourceLocation direct constructor
sl = Google::Logging::SourceLocation.new(file: "app.rb", line: "42", function: "run")
puts sl.file
puts sl.line
puts sl.function
puts sl.to_h.inspect

# 6. Message equality
m5 = Google::Logging::Message.from("hello world")
puts (m1 == m5).inspect
puts (m1 == m2).inspect

# 7. Labels normalization
m6 = Google::Logging::Message.new(
  message: "labeled",
  labels: { env: "prod", count: 3 }
)
puts m6.labels["env"]
puts m6.labels["count"]

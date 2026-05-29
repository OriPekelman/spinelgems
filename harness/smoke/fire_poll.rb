# FirePoll smoke: exercises module_function API with immediately-succeeding blocks

# poll: block returns truthy immediately, returns block value
result = FirePoll.poll("should not fail") { 42 }
puts result

# poll with explicit short timeout, succeeds immediately
result2 = FirePoll.poll("nope", 5.0) { "done" }
puts result2

# patiently: block succeeds immediately, returns block value
result3 = FirePoll.patiently(5, 0.1) { 99 }
puts result3

# patiently catches exception on first attempt but succeeds on second
attempt = 0
result4 = FirePoll.patiently(5, 0.01) do
  attempt += 1
  raise "first" if attempt < 2
  "ok"
end
puts result4

# poll raises when block always returns falsy within timeout
begin
  FirePoll.poll("timed out test", 0.05) { false }
rescue RuntimeError => e
  puts e.message
end

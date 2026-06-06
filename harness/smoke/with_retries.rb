require 'with_retries'

# Test 1: succeeds on first attempt (no retry needed)
result = with_retries([StandardError], attempts: 3) { 42 }
puts "direct_success: #{result}"

# Test 2: fails twice, then succeeds — counts retries
attempts_made = 0
result = with_retries([RuntimeError], attempts: 3) do
  attempts_made += 1
  raise RuntimeError, "transient" if attempts_made < 3
  "ok_after_#{attempts_made}"
end
puts "retry_success: #{result}"
puts "attempts_made: #{attempts_made}"

# Test 3: exhausts all retries and re-raises
error_class = nil
begin
  with_retries([ArgumentError], attempts: 2) { raise ArgumentError, "always fails" }
rescue ArgumentError => e
  error_class = e.class
end
puts "exhausted_reraise: #{error_class}"

# Test 4: non-matching error class propagates immediately (not retried)
counter = 0
begin
  with_retries([RuntimeError], attempts: 5) do
    counter += 1
    raise TypeError, "wrong type"
  end
rescue TypeError
  # expected
end
puts "non_matching_attempts: #{counter}"

# Test 5: missing :attempts raises ArgumentError
begin
  with_retries([StandardError]) { 1 }
rescue ArgumentError => e
  puts "missing_attempts: ArgumentError"
end

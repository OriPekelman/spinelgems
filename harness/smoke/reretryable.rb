include Retryable

# Simple success case
result = retryable(tries: 1) { 42 }
puts result

# Returns nil when tries is 0
result2 = retryable(tries: 0) { 99 }
puts result2.nil?

# Retries on exception, eventually succeeds
attempts = 0
result3 = retryable(tries: 3, on: RuntimeError) do
  attempts += 1
  raise RuntimeError, "fail" if attempts < 2
  attempts
end
puts result3
puts attempts

# No exception raised, single try
result4 = retryable(tries: 2) { "hello" }
puts result4

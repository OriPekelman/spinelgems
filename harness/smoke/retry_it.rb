puts RetryIt::MAX_RUNS
puts RetryIt::DEFAULT_TIMEOUT_S
puts RetryIt::DEFAULT_EXCEPTIONS.inspect

# Test retry_it method with no errors (success on first attempt)
class Tester
  include RetryIt
end

t = Tester.new
result = t.retry_it(max_runs: 3, errors: [StandardError], timeout: 0) { 42 }
puts result

# Test with a retry that eventually succeeds
attempts = 0
result2 = t.retry_it(max_runs: 5, errors: [RuntimeError], timeout: 0) do
  attempts += 1
  raise RuntimeError, "fail" if attempts < 3
  "done"
end
puts result2
puts attempts

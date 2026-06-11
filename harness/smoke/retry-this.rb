# Smoke for retry-this 1.1 — RetryThis module
# The harness prepends: require_relative ".../lib/retry-this"
# retry-this.rb just does `require 'retry_this'` which Spinel won't resolve.
# So we require_relative the actual implementation directly here.
require_relative "/home/oripekelman/.cache/spinel-compat/gems/retry-this-1.1/lib/retry_this"

# 1. Succeeds on first attempt
result = RetryThis.retry_this(times: 3) { |attempt| "ok_#{attempt}" }
puts result

# 2. Succeeds on second attempt after one failure
attempts = 0
result = RetryThis.retry_this(times: 3) do |attempt|
  attempts += 1
  raise StandardError, "fail" if attempts < 2
  "recovered_#{attempt}"
end
puts result

# 3. Retries exact number of times before success
counter = 0
result = RetryThis.retry_this(times: 4) do |attempt|
  counter += 1
  raise RuntimeError if counter < 3
  "third_#{attempt}"
end
puts result

# 4. Raises after exhausting retries
begin
  RetryThis.retry_this(times: 2) { raise ArgumentError, "always" }
rescue ArgumentError => e
  puts "caught: #{e.message}"
end

# 5. Default times=1 means 2 total attempts
begin
  RetryThis.retry_this { raise RuntimeError, "default" }
rescue RuntimeError => e
  puts "default_caught: #{e.message}"
end

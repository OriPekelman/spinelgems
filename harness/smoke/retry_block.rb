# Basic retry that succeeds on first attempt
result = retry_block(attempts: 3) { |n| "success on attempt #{n}" }
puts result

# Retry that fails twice then succeeds
counter = 0
result = retry_block(attempts: 5) do |n|
  counter += 1
  raise "fail" if counter < 3
  "done after #{n} tries"
end
puts result

# Verify attempts count is tracked
attempts_seen = []
begin
  retry_block(attempts: 3) do |n|
    attempts_seen << n
    raise RuntimeError, "always fails"
  end
rescue RuntimeError
  puts attempts_seen.inspect
end

# Catch specific exception type
caught = nil
begin
  retry_block(attempts: 2, catch: ArgumentError) do |n|
    raise RuntimeError, "not caught"
  end
rescue RuntimeError => e
  caught = e.message
end
puts caught

# do_not_catch option
protected_error = nil
begin
  retry_block(attempts: 3, catch: StandardError, do_not_catch: RuntimeError) do |n|
    raise RuntimeError, "protected"
  end
rescue RuntimeError => e
  protected_error = e.message
end
puts protected_error

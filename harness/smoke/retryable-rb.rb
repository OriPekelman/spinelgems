require 'retryable'

# 1. Basic retry: block raises twice, succeeds on third attempt
attempts = 0
result = Retryable.retryable(:on => RuntimeError, :times => 3, :sleep => false) do
  attempts += 1
  raise RuntimeError, "oops" if attempts < 3
  "done after #{attempts}"
end
puts result                   # => done after 3
puts "attempts=#{attempts}"   # => attempts=3

# 2. :then callback fires on each retry
retry_log = []
begin
  Retryable.retryable(
    :on    => ArgumentError,
    :times => 2,
    :sleep => false,
    :then  => lambda { |e, h, a, r, t| retry_log << "retry #{a}/#{t}" }
  ) do
    raise ArgumentError, "bad"
  end
rescue ArgumentError
  # expected after exhausting retries
end
puts retry_log.join(", ")     # => retry 1/2, retry 2/2, retry 3/2

# 3. :finally callback fires when retries exhausted
final_attempts = nil
begin
  Retryable.retryable(
    :on      => EOFError,
    :times   => 1,
    :sleep   => false,
    :finally => lambda { |e, h, a, r, t| final_attempts = a }
  ) do
    raise EOFError, "eof"
  end
rescue EOFError
  # expected
end
puts "final_attempts=#{final_attempts}"   # => final_attempts=2

# 4. :always callback fires regardless of outcome (success path)
always_called = false
Retryable.retryable(
  :on     => RuntimeError,
  :times  => 1,
  :sleep  => false,
  :always => lambda { |h, a, r, t| always_called = true }
) do
  "ok"
end
puts "always_called=#{always_called}"     # => always_called=true

# 5. Handler hash shared between iterations
Retryable.retryable(:on => StandardError, :times => 2, :sleep => false) do |h|
  h[:count] ||= 0
  h[:count] += 1
  raise StandardError, "retry" if h[:count] < 2
  puts "handler_count=#{h[:count]}"       # => handler_count=2
end

# 6. Multiple exception types
rescued_class = nil
begin
  Retryable.retryable(:on => [IOError, TypeError], :times => 1, :sleep => false) do
    raise TypeError, "wrong type"
  end
rescue TypeError => e
  rescued_class = e.class
end
puts "rescued=#{rescued_class}"           # => rescued=TypeError

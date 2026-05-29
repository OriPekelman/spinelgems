puts SimpleCircuitBreaker::VERSION
cb = SimpleCircuitBreaker.new(3, 10)
puts cb.failure_threshold
puts cb.retry_timeout
# Successful call returns value
result = cb.handle { 42 }
puts result
# Accumulate failures to trip the breaker
3.times do
  begin
    cb.handle(RuntimeError) { raise RuntimeError, "fail" }
  rescue RuntimeError
    # expected
  end
end
# Now the circuit should be open
begin
  cb.handle { "should not run" }
rescue SimpleCircuitBreaker::CircuitOpenError => e
  puts e.message
end
puts "done"

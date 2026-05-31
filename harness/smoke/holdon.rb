# HoldOn smoke: pure constant and immediate-resolution paths (no sleep)
puts HoldOn::Timeout.name
puts HoldOn::Timeout.superclass.name

# delay_until with a block that returns true immediately (no sleep, no timeout)
result = HoldOn.delay_until(timeout: 10, interval: 0.001) { true }
puts result.inspect

# delay_while with a block that returns false immediately (no sleep, no timeout)
result2 = HoldOn.delay_while(timeout: 10, interval: 0.001) { false }
puts result2.inspect

# Timeout exception class ancestry
puts HoldOn::Timeout.ancestors.include?(StandardError)

require 'server_health_check'

# Test basic initialization
hc = ServerHealthCheck.new
puts hc.results.inspect   # => {}
puts hc.ok?.inspect       # => true (no checks = vacuously true)

# Test check! with a passing block
hc.check!('db') { 2 + 2 == 4 }
puts hc.results[:db]      # => OK
puts hc.ok?.inspect       # => true

# Test check! with a failing block
hc.check!('cache') { false }
puts hc.results[:cache]   # => Failed
puts hc.ok?.inspect       # => false

# Test check! with an exception inside the block
hc2 = ServerHealthCheck.new
hc2.check!('broken') { raise ArgumentError, "something went wrong" }
puts hc2.results[:broken] # => "something went wrong"
puts hc2.ok?.inspect      # => false

# Test check! using a custom name as symbol
hc3 = ServerHealthCheck.new
hc3.check!('queue') { 1 == 1 }
hc3.check!('workers') { 42 > 0 }
puts hc3.ok?.inspect      # => true
puts hc3.results.keys.sort.inspect

# Test VERSION constant
puts ServerHealthCheck::VERSION

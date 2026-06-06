# rake-performance: the only non-Rake logic lives in TimeHelper (time_helper.rb).
# The main rake_performance.rb monkey-patches Rake::Task which needs Rake loaded.
# We smoke TimeHelper directly via require_relative into its lib path.
require 'time_helper'

# TimeHelper.time_difference(a, b) formats abs(a - b) as HH:MM:SS.
# The method swaps a and b when a < b.

t0 = Time.now
t1 = t0 + 3661  # 1 hour, 1 minute, 1 second ahead

result = TimeHelper.time_difference(t0, t1)
puts result  # => "01:01:01"

# Order-independence: passing (t1, t0) should give same result
result2 = TimeHelper.time_difference(t1, t0)
puts result2  # => "01:01:01"

# Zero difference
result3 = TimeHelper.time_difference(t0, t0)
puts result3  # => "00:00:00"

# 90 seconds = 0h 1m 30s
t3 = t0 + 90
result4 = TimeHelper.time_difference(t3, t0)
puts result4  # => "00:01:30"

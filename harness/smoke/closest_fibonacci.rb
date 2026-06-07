require 'closest_fibonacci'

# In Ruby >= 2.5, Fixnum was removed and merged into Integer.
# The gem only includes Fibonacci into Float and Fixnum; extend Integer manually.
class Integer; include Fibonacci; end

# closest_fibonacci returns the largest Fibonacci number strictly less than self.
# Use small inputs only — the gem uses naive recursive Fibonacci (O(2^n)).
puts 2.closest_fibonacci       # 1
puts 6.closest_fibonacci       # 5
puts 9.closest_fibonacci       # 8
puts 14.closest_fibonacci      # 13

# Float values
puts 1.5.closest_fibonacci     # 1
puts 6.5.closest_fibonacci     # 5
puts 14.1.closest_fibonacci    # 13

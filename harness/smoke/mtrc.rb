require 'mtrc'

# Exercise Mtrc::SortedSamples — sorted insertion + percentile retrieval via at()
s = Mtrc::SortedSamples.new
[5, 1, 9, 3, 7, 2, 8, 4, 6, 10].each { |n| s << n }

puts s.size          # 10
puts s.min           # 1
puts s.max           # 10
puts s.at(0.0)       # 1  (0th percentile)
puts s.at(0.5)       # 6  (50th percentile)
puts s.at(0.9)       # 10 (90th percentile)
puts s.at(1.0)       # 10 (100th percentile, clamped to last)
puts s.median        # 6  (same as at(0.5))

# Exercise Mtrc::Sample — key/value Comparable
a = Mtrc::Sample.new(3, "three")
b = Mtrc::Sample.new(7, "seven")
c = Mtrc::Sample.new(1, "one")

puts (a <=> b)       # -1
puts (b <=> a)       # 1
puts (a <=> a)       # 0
puts [b, a, c].sort.map(&:value).join(",")  # one,three,seven

# SortedSamples with Sample objects, using at() for percentile
ss = Mtrc::SortedSamples.new
ss << Mtrc::Sample.new(10, "ten")
ss << Mtrc::Sample.new(1, "one")
ss << Mtrc::Sample.new(5, "five")
puts ss.min.value      # one
puts ss.max.value      # ten
puts ss.at(0.5).value  # five

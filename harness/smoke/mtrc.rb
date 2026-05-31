# smoke: mtrc - SortedSamples percentile operations
s = Mtrc::SortedSamples.new
[5, 1, 3, 2, 4].each { |n| s << n }
puts s.size
puts s.min
puts s.max
puts s.median
puts s % 0
puts s % 100
puts s % 50
puts s.at(0.0)
puts s.at(1.0)
puts Mtrc::VERSION

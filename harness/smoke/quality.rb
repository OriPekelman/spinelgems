# Smoke test for quality-measure-engine gem
# Tests the self-contained CVAggregator (pure Ruby, no external deps)
# Avoids mongoid/delayed_job by loading only the pure-Ruby files directly

GEM_LIB = "/home/oripekelman/.cache/spinel-compat/gems/quality-measure-engine-3.2.0/lib"

# Load version constant directly
require GEM_LIB + "/qme/version"

# Load CVAggregator directly (no external deps)
require GEM_LIB + "/qme/map/cv_aggregator"

puts "VERSION: #{QME::VERSION}"

# Test CVAggregator.median with odd-sized frequency distribution
# frequencies: {10 => 2, 20 => 1, 30 => 2} -> sorted values [10,10,20,30,30], median = 20
freqs_odd = {10 => 2, 20 => 1, 30 => 2}
puts "median(odd): #{QME::MapReduce::CVAggregator.median(freqs_odd)}"

# Test CVAggregator.median with even-sized distribution
# frequencies: {5 => 2, 15 => 2} -> values [5,5,15,15], median = (5+15)/2 = 10
freqs_even = {5 => 2, 15 => 2}
puts "median(even): #{QME::MapReduce::CVAggregator.median(freqs_even)}"

# Test CVAggregator.mean
# {4 => 3, 10 => 1} -> sum = 4*3 + 10*1 = 22, count = 4, mean = 5
freqs_mean = {4 => 3, 10 => 1}
puts "mean: #{QME::MapReduce::CVAggregator.mean(freqs_mean)}"

# Test median with single-element distribution
freqs_single = {42 => 1}
puts "median(single): #{QME::MapReduce::CVAggregator.median(freqs_single)}"

# Test mean with empty frequencies (should return 0)
puts "mean(empty): #{QME::MapReduce::CVAggregator.mean({})}"

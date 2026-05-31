# Smoke: histogram gem - exercises Histogram module class methods (pure, no external deps)

data = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]

puts Histogram.minmax(data).inspect
puts Histogram.median(data.sort).round(2)

mean, stddev = Histogram.sample_stats(data)
puts mean.round(4)
puts stddev.round(4)

puts Histogram.iqrange(data, method: :tukey).round(4)
puts Histogram.iqrange(data, method: :moore_mccabe).round(4)

puts Histogram::DEFAULT_BIN_METHOD.inspect
puts Histogram::DEFAULT_QUARTILE_METHOD.inspect

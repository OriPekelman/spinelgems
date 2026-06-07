require 'weighted_sample'

# Seed rand for deterministic output
srand(42)

# Basic weighted sample: run many samples and count distribution
items = [:apple, :banana, :cherry]
counts = Hash.new(0)
1000.times do
  result = items.weighted_sample_by { |item| items.index(item) + 1 }
  counts[result] += 1
end

counts.sort_by { |k, _| k.to_s }.each do |item, count|
  puts "#{item}: #{count}"
end

# Verify with a single-element collection (always returns that element)
srand(1)
single = [:only].weighted_sample_by { |_| 5 }
puts "single: #{single}"

# Error handling: all-zero weights should raise
begin
  [1, 2, 3].weighted_sample_by { |_| 0 }
  puts "no_error"
rescue ArgumentError => e
  puts "error: #{e.message}"
end

# Error handling: float weight should raise
begin
  [:x].weighted_sample_by { |_| 1.5 }
  puts "no_error"
rescue ArgumentError => e
  puts "error: #{e.message}"
end

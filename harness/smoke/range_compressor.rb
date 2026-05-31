# Basic compression of integers
result = RangeCompressor.compress([1, 2, 3, 5, 6, 7, 10])
puts result.map(&:to_s).inspect

# Single element
result2 = RangeCompressor.compress([42])
puts result2.map(&:to_s).inspect

# Already a range input
result3 = RangeCompressor.compress([1..5, 8, 9, 10])
puts result3.map(&:to_s).inspect

# Unsorted and duplicates
result4 = RangeCompressor.compress([5, 3, 3, 4, 1, 2])
puts result4.map(&:to_s).inspect

# Empty
result5 = RangeCompressor.compress([])
puts result5.inspect

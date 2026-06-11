# Smoke for clause_extractor — tests pure utility methods that need no external data
# prioritize_ranges: manages a list of non-overlapping ranges
r1 = ClauseExtractor.prioritize_ranges([], 0, 3, "match one")
puts r1.inspect

r2 = ClauseExtractor.prioritize_ranges([(0..3)], 0, 5, "longer match")
puts r2.inspect

r3 = ClauseExtractor.prioritize_ranges([(0..5), (8..10)], 1, 4, "inside existing")
puts r3.inspect

r4 = ClauseExtractor.prioritize_ranges([(0..5), (8..10)], 6, 12, "overlaps second")
puts r4.inspect

# get_match_start_index: locates verb position within match
lo, hi = ClauseExtractor.get_match_start_index("run", "she will run", 2)
puts lo
puts hi

lo2, hi2 = ClauseExtractor.get_match_start_index("go", "they should go home", 3)
puts lo2
puts hi2

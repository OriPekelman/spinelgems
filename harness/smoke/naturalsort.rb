# smoke: naturalsort — NaturalSort.sort, NaturalSort.comparator, #natural_sort instance method
require 'natural_sort'

# 1. Basic alphanumeric sort (the canonical use case)
result = NaturalSort.sort(['a12', 'a1', 'a2', 'a10'])
puts result.inspect

# 2. Mixed case + numbers
result2 = NaturalSort.sort(['img10.png', 'img2.png', 'img1.png', 'img20.png'])
puts result2.inspect

# 3. Comparator used directly (returns -1, 0, or 1)
puts NaturalSort.comparator('a2', 'a10')
puts NaturalSort.comparator('file10', 'file10')
puts NaturalSort.comparator('b1', 'a2')

# 4. Sort via the instance method (include NaturalSort in Array-like)
class FileList
  include NaturalSort
  def initialize(items); @items = items; end
  def to_a; @items; end
end
fl = FileList.new(['z9', 'z10', 'z1', 'z2'])
puts fl.natural_sort.inspect

# 5. Strings without numbers (pure lexicographic path)
puts NaturalSort.sort(['banana', 'apple', 'cherry']).inspect

# 6. Leading zeros / zero-padded numbers
puts NaturalSort.sort(['item003', 'item1', 'item02', 'item10']).inspect

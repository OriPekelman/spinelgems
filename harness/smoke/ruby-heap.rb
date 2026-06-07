require 'Heap'

# MinHeap: insert elements, check extract_min and sort
min_heap = Heap::BinaryHeap::MinHeap.new([5, 3, 8, 1, 4])
puts "MinHeap count: #{min_heap.count}"
puts "MinHeap min: #{min_heap.extract_min}"
sorted_asc = min_heap.sort
puts "MinHeap sorted: #{sorted_asc.inspect}"

# MaxHeap: insert elements, check extract_max and sort
max_heap = Heap::BinaryHeap::MaxHeap.new([5, 3, 8, 1, 4])
puts "MaxHeap count: #{max_heap.count}"
puts "MaxHeap max: #{max_heap.extract_max}"
sorted_desc = max_heap.sort
puts "MaxHeap sorted: #{sorted_desc.inspect}"

# Add elements to a MinHeap and extract one by one
min2 = Heap::BinaryHeap::MinHeap.new
min2.add(10)
min2.add(2)
min2.add(7)
min2.add([6, 1])
extracted = []
extracted << min2.extract_min! while min2.count > 0
puts "MinHeap extracted in order: #{extracted.inspect}"

# MaxHeap: verify add array and sort
max2 = Heap::BinaryHeap::MaxHeap.new
max2.add([15, 3, 9, 21, 7])
puts "MaxHeap after add array sorted desc: #{max2.sort.inspect}"

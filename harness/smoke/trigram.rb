require 'trigram'

# Test 1: identical strings => similarity = 1.0
sim = Trigram.compare("hello world", "hello world")
puts "identical: #{sim}"

# Test 2: completely different strings => similarity = 0.0
sim2 = Trigram.compare("abc", "xyz")
puts "disjoint: #{sim2}"

# Test 3: partial overlap - "hello" vs "helo"
sim3 = Trigram.compare("hello", "helo")
puts "partial: #{sim3.round(4)}"

# Test 4: trigram similarity is symmetric
a = "kitten"
b = "sitting"
sim4a = Trigram.compare(a, b)
sim4b = Trigram.compare(b, a)
puts "symmetric: #{sim4a == sim4b}"

# Test 5: similar strings have higher similarity than dissimilar
high = Trigram.compare("programming", "programmer")
low  = Trigram.compare("programming", "xyz")
puts "ordering: #{high > low}"

# Test 6: version constant
puts "version: #{Trigram::VERSION}"

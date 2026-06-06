require 'scanf'

# Test 1: String#scanf with integer and string format
result = "42 hello".scanf("%d%s")
puts result.inspect
# => [42, "hello"]

# Test 2: String#scanf with multiple integers
result = "10 20 30".scanf("%d %d %d")
puts result.inspect
# => [10, 20, 30]

# Test 3: String#scanf with float
result = "3.14 world".scanf("%f%s")
puts result[0].round(2).inspect
puts result[1].inspect
# => 3.14
# => "world"

# Test 4: String#scanf with hex
result = "ff 255".scanf("%x%d")
puts result.inspect
# => [255, 255]

# Test 5: String#scanf with octal
result = "077".scanf("%o")
puts result.inspect
# => [63]

# Test 6: String#scanf with block (iterative scanning)
results = "1 apple 2 banana 3 cherry".scanf("%d%s") { |n, s| "#{n}:#{s.upcase}" }
puts results.inspect
# => ["1:APPLE", "2:BANANA", "3:CHERRY"]

# Test 7: Assignment suppression with %*
result = "100 ignored 200".scanf("%d%*s%d")
puts result.inspect
# => [100, 200]

# Test 8: Field width limit
result = "12345".scanf("%3d%2d")
puts result.inspect
# => [123, 45]

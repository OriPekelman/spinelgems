require 'enumerable_hashify'

# Basic hashify: keys are elements, values default to true
result1 = [1, 2, 3, 4].hashify
puts result1.sort.inspect

# hashify with a custom default value
result2 = [1, 2, 3, 4].hashify("a")
puts result2.sort.inspect

# hashify with a block: value derived from each key
result3 = [1, 2, 3, 4].hashify { |n| "a" * n }
puts result3.sort.inspect

# hashify on a range
result4 = (1..5).hashify(0)
puts result4.sort.inspect

# hashify on an array of strings
result5 = ["foo", "bar", "baz"].hashify { |s| s.upcase }
puts result5.sort.inspect

# hashify on an empty array
result6 = [].hashify
puts result6.inspect

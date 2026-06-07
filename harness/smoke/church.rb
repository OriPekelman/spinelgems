require 'church'

# MAP: double each element
doubled = Church::MAP[[1, 2, 3, 4, 5], &-> x { x * 2 }]
puts doubled.inspect

# FILTER: keep only evens
evens = Church::FILTER[[1, 2, 3, 4, 5, 6], &-> x { x % 2 == 0 }]
puts evens.inspect

# SORT: sort array
sorted = Church::SORT[[5, 3, 1, 4, 2]]
puts sorted.inspect

# PRIME: test primality
primes = Church::FILTER[[*2..20], &Church::PRIME]
puts primes.inspect

# COMPOSE: compose two lambdas
double = -> x { x * 2 }
increment = -> x { x + 1 }
double_then_increment = Church::COMPOSE[increment, double]
puts double_then_increment[7]

# SIZE and REDUCE: sum of an array
arr = [10, 20, 30, 40]
puts Church::SIZE[arr]
total = Church::REDUCE[arr, &:+]
puts total

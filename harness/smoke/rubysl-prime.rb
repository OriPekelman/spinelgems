# rubysl-prime: prime numbers and factorization library
# The harness prepends require_relative of the gem's lib files; no require needed here.

# Test 1: Prime.prime? - primality checking
puts Prime.prime?(2)    # true
puts Prime.prime?(4)    # false
puts Prime.prime?(97)   # true
puts Prime.prime?(100)  # false

# Test 2: Prime.each with upper bound - list primes up to 30
primes_to_30 = []
Prime.each(30) { |p| primes_to_30 << p }
puts primes_to_30.inspect  # [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]

# Test 3: Prime.prime_division - factorization
puts Prime.prime_division(12).inspect    # [[2, 2], [3, 1]]
puts Prime.prime_division(360).inspect  # [[2, 3], [3, 2], [5, 1]]

# Test 4: Prime.int_from_prime_division - recompose from factors
puts Prime.int_from_prime_division([[2, 2], [3, 1]])             # 12
puts Prime.int_from_prime_division([[2, 3], [3, 2], [5, 1]])    # 360

# Test 5: Integer#prime? extension method
puts 17.prime?   # true
puts 18.prime?   # false

# Test 6: Integer#prime_division extension method
puts 42.prime_division.inspect  # [[2, 1], [3, 1], [7, 1]]

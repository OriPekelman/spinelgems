# Faker::ISBN smoke — deterministic by passing a fixed rand_seed
puts Faker::ISBN.thirteen_digit(0)
puts Faker::ISBN.thirteen_digit(1)
puts Faker::ISBN.thirteen_digit(123456789)
puts Faker::ISBN.thirteen_digit(999999998)
puts Faker::ISBN.thirteen_digit(500000000)

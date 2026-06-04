require 'luhn'

# Luhn::sum_of — digit-sum of a number
puts Luhn.sum_of(10)    # => 1
puts Luhn.sum_of(22)    # => 4
puts Luhn.sum_of(99)    # => 18

# Luhn::luhn_doubled — doubles alternate digits from the right
puts Luhn.luhn_doubled(123).inspect     # => [2, 2, 6]
puts Luhn.luhn_doubled(700).inspect     # => [14, 0, 0]
puts Luhn.luhn_doubled(4992739871).inspect  # => [4, 18, 9, 4, 7, 6, 9, 16, 7, 2]

# Luhn::checksum — compute check digit
puts Luhn.checksum(123)          # => 0
puts Luhn.checksum(700)          # => 5
puts Luhn.checksum(199600)       # => 8
puts Luhn.checksum(4992739871)   # => 6

# Luhn::valid? — validate a full Luhn number
puts Luhn.valid?(1230)                # => true
puts Luhn.valid?(1996008)             # => true
puts Luhn.valid?(123451234512348)     # => true
puts Luhn.valid?(1231)                # => false (bad check digit)
puts Luhn.valid?(4992739871)          # => false (no check digit appended)

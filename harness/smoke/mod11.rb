# mod11 smoke — Mod11 check digit calculations
m = Mod11.new(1234)
puts m.check_digit
puts m.full_value

m2 = Mod11.new(9999)
puts m2.check_digit
puts m2.full_value

m3 = Mod11.new(1)
puts m3.check_digit.inspect
puts m3.full_value

puts Mod11::WEIGHT.first
puts Mod11::WEIGHT.length

require 'ird-validator'

# IRD (NZ Inland Revenue Dept) number validator smoke
# Tests validate() with known-valid and known-invalid NZ IRD numbers,
# and exercises the weighted_check helper directly.

# Known valid IRD numbers (NZ-format, 8 or 9 digits)
valid_irds = [49091850, 136410132, 49098576]
invalid_irds = [12345678, 99999999, 0, 5000000, 200000000]

valid_irds.each do |n|
  puts "validate(#{n}) => #{IRD::Validator.validate(n)}"
end

invalid_irds.each do |n|
  puts "validate(#{n}) => #{IRD::Validator.validate(n)}"
end

# Also test with string input (dashes stripped internally)
puts "validate('49-091-850') => #{IRD::Validator.validate('49-091-850')}"

# weighted_check directly
puts "weighted_check(49091850, 32765432) => #{IRD::Validator.weighted_check(49091850, 32765432)}"
puts "weighted_check(136410132, 32765432) => #{IRD::Validator.weighted_check(136410132, 32765432)}"

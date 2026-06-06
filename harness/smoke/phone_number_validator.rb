require 'phone_number_validator'

# Valid US phone numbers in various formats
valid_numbers = [
  '+1 (987) 654-3210 ext. 198842',
  '(800) 555-1234',
  '800-555-1234',
  '8005551234',
  '+1 212-555-0100',
  '1 (650) 253-0000',
]

# Invalid numbers
invalid_numbers = [
  '+1 (987 778873-321a0 ext.ff99',
  '123-456-7890',   # area code starts with 1
  '000-000-0000',
  'not-a-phone',
  '555-1234',       # too short, no area code
]

puts "=== Valid numbers ==="
valid_numbers.each do |num|
  result = PhoneNumberValidator.validate(num)
  puts "#{num.inspect} => #{result.inspect}"
end

puts "=== Invalid numbers ==="
invalid_numbers.each do |num|
  result = PhoneNumberValidator.validate(num)
  puts "#{num.inspect} => #{result.inspect}"
end

puts "=== Empty string ==="
puts PhoneNumberValidator.validate('').inspect

puts "=== Validator instance directly ==="
v = PhoneNumberValidator::Validator.new('(312) 555-0199')
puts v.validate.inspect

v2 = PhoneNumberValidator::Validator.new('not-a-number')
puts v2.validate.inspect

puts "=== PHONE_NUMBER_REGEX ==="
puts PhoneNumberValidator::Validator::PHONE_NUMBER_REGEX.class
puts (PhoneNumberValidator::Validator::PHONE_NUMBER_REGEX =~ '(800) 555-1212') ? 'match' : 'no-match'

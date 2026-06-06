require 'usi'

# LuhnCheck: generate check characters for known strings
chars = Usi::Validator::VALID_CHARACTERS
checker = Usi::LuhnCheck.new(chars)

# Generate check character for a 9-char string
check1 = checker.generate("2ABCDEFGH")
puts "check1=#{check1}"

check2 = checker.generate("ABCDEFGHJ")
puts "check2=#{check2}"

# Validator: valid USI (9 chars + correct check digit)
candidate = "2ABCDEFGH" + check1
v1 = Usi::Validator.new(candidate)
puts "valid1=#{v1.valid?}"

# Validator: invalid USI (wrong check digit)
wrong = "2ABCDEFGHZ"
v2 = Usi::Validator.new(wrong)
puts "valid2=#{v2.valid?}"

# Validator: too short
short = "2ABCDE"
v3 = Usi::Validator.new(short)
puts "valid3=#{v3.valid?}"

# LuhnCheck alternate_factor
lc = Usi::LuhnCheck.new(chars)
puts "alt2=#{lc.alternate_factor(2)}"
puts "alt1=#{lc.alternate_factor(1)}"

# base_n should equal number of valid characters (32)
puts "base_n=#{lc.base_n}"

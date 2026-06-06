# frozen_string_literal: true

require 'creditcard_identifier'

# --- Luhn validation ---
puts CreditcardIdentifier.luhn('4532015112830366')   # valid Visa  => true
puts CreditcardIdentifier.luhn('4532015112830367')   # bad check  => false
puts CreditcardIdentifier.luhn('378282246310005')    # valid Amex => true

# --- Brand identification ---
visa_brand   = CreditcardIdentifier.find_brand('4532015112830366')
amex_brand   = CreditcardIdentifier.find_brand('378282246310005')
mc_brand     = CreditcardIdentifier.find_brand('5425233430109903')
unknown      = CreditcardIdentifier.find_brand('0000000000000000')

puts visa_brand[:name]   # => visa
puts amex_brand[:name]   # => amex
puts mc_brand[:name]     # => mastercard
puts unknown.nil?        # => true

# --- supported? ---
puts CreditcardIdentifier.supported?('4532015112830366')  # => true
puts CreditcardIdentifier.supported?('9999999999999999')  # => false (no brand)

# --- CVV validation ---
puts CreditcardIdentifier.validate_cvv('123', 'visa')    # 3-digit => true
puts CreditcardIdentifier.validate_cvv('1234', 'visa')   # 4-digit => false
puts CreditcardIdentifier.validate_cvv('1234', 'amex')   # 4-digit => true
puts CreditcardIdentifier.validate_cvv('123', 'amex')    # 3-digit => false

# --- Validator instance ---
v = CreditcardIdentifier::Validator.new
brands = v.list_brands
puts brands.include?('visa')        # => true
puts brands.include?('mastercard')  # => true
puts brands.length > 10             # => true (many brands)

brand_info = v.get_brand_info('visa')
puts brand_info[:name]              # => visa
puts v.luhn('4532015112830366')     # => true

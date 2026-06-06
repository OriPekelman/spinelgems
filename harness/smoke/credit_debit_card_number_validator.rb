require 'credit_debit_card_number_validator'

V = CreditDebitCardNumberValidator::Validator

# Luhn-valid Visa test number (4929334156772439)
visa = '4929334156772439'
puts V.luhn_test(visa)                  # true
puts V.mod_10_result(visa)              # 0
puts V.determine_brand(visa)            # Visa
puts V.number_length(visa)              # 16

# Luhn-valid AmEx test number (378282246310005)
amex = '378282246310005'
puts V.luhn_test(amex)                  # true
puts V.determine_brand(amex)            # American Express

# Invalid number (Luhn check fails)
bad = '4111111111111112'
puts V.luhn_test(bad)                   # false
puts V.mod_10_result(bad)               # non-zero

# all_information_about
info = V.all_information_about(visa)
puts info.brand                         # Visa
puts info.is_valid                      # true
puts info.length                        # 16

# MasterCard (5500005555555559)
mc = '5500005555555559'
puts V.luhn_test(mc)                    # true
puts V.determine_brand(mc)              # Master Card

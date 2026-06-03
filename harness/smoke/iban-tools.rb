require 'iban-tools'

# Valid German IBAN
de_iban = IBANTools::IBAN.new("DE89370400440532013000")
puts de_iban.code
puts de_iban.country_code
puts de_iban.check_digits
puts de_iban.bban
puts de_iban.prettify
puts de_iban.validation_errors.inspect
puts IBANTools::IBAN.valid?("DE89370400440532013000")

# Invalid IBAN (bad check digits)
bad = IBANTools::IBAN.new("DE00370400440532013000")
puts bad.validation_errors.inspect
puts IBANTools::IBAN.valid?("DE00370400440532013000")

# Valid UK IBAN
gb_iban = IBANTools::IBAN.new("GB29NWBK60161331926819")
puts gb_iban.code
puts gb_iban.prettify
puts gb_iban.validation_errors.inspect
puts IBANTools::IBAN.valid?("GB29NWBK60161331926819")

# Canonicalization: strips whitespace, upcases
raw = IBANTools::IBAN.canonicalize_code("  de89 3704 0044 0532 0130 00  ")
puts raw

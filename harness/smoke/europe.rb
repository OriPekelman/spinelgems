# frozen_string_literal: true
require 'europe'

# 1. Country lookup
de = Europe::Countries::COUNTRIES[:DE]
puts "Germany name: #{de[:name]}"
puts "Germany capital: #{de[:capital]}"
puts "Germany currency: #{de[:currency]}"
puts "Germany TLD: #{de[:tld]}"

# 2. Eurozone countries (sorted for determinism)
eurozone = Europe::Countries.eurozone
if eurozone.is_a?(Array)
  puts "Eurozone count: #{eurozone.size}"
  puts "Eurozone includes FR: #{eurozone.include?(:FR)}"
else
  # If only one EUR country remained, would be a symbol
  puts "Eurozone: #{eurozone}"
end

# 3. VAT format validation (pure local, no network)
puts "DE VAT valid: #{Europe::Vat::Format.validate('DE123456789')}"
puts "DE VAT invalid: #{Europe::Vat::Format.validate('DE12345')}"
puts "FR VAT valid: #{Europe::Vat::Format.validate('FRAA123456789')}"
puts "NL VAT valid: #{Europe::Vat::Format.validate('NL123456789B01')}"
puts "UK VAT (not in list): #{Europe::Vat::Format.validate('GB123456789')}"

# 4. Fallback VAT rates
de_rate = Europe::Vat::Rates::FALLBACK_RATES[:DE]
fr_rate = Europe::Vat::Rates::FALLBACK_RATES[:FR]
puts "DE VAT rate: #{de_rate}"
puts "FR VAT rate: #{fr_rate}"
puts "Fallback countries count: #{Europe::Vat::Rates::FALLBACK_RATES.size}"

# 5. Currency info
eur = Europe::Currency::CURRENCIES[:EUR]
puts "EUR name: #{eur[:name]}"
puts "EUR symbol: #{eur[:symbol]}"
gbp = Europe::Currency::CURRENCIES[:GBP]
puts "GBP name: #{gbp[:name]}"

# frozen_string_literal: true
# Smoke test for latinum gem — exercises Resource arithmetic, Collection, and Bank formatting.
require 'latinum'
require 'latinum/currencies/global'
require 'bigdecimal'

# 1. Resource parsing and arithmetic
a = Latinum::Resource.parse("10.50 USD")
b = Latinum::Resource.parse("4.25 USD")
puts (a + b).to_s           # 14.75 USD
puts (a - b).to_s           # 6.25 USD
puts (a * 2).to_s           # 21.0 USD
puts a.zero?                # false
puts Latinum::Resource.parse("0 USD").zero? # true
puts (a <=> b)              # 1

# 2. Resource exchange (manual rate)
usd = Latinum::Resource.parse("100.00 USD")
eur = usd.exchange(BigDecimal("0.85"), "EUR", 2)
puts eur.to_s               # 85.0 EUR

# 3. Collection aggregation
col = Latinum::Collection.new
col << Latinum::Resource.parse("5.00 USD")
col << Latinum::Resource.parse("3.00 USD")
col << Latinum::Resource.parse("2.00 GBP")
puts col["USD"].to_s        # 8.0 USD
puts col["GBP"].to_s        # 2.0 GBP
puts col.empty?             # false

# 4. Bank with global currencies — format and round
bank = Latinum::Bank.new(Latinum::Currencies::Global)
resource = Latinum::Resource.parse("9.999 NZD")
rounded = bank.round(resource)
puts rounded.to_s           # 10.0 NZD
puts bank.format(resource)  # $9.999 NZD

# 5. Bank exchange rate
bank << Latinum::ExchangeRate.new("USD", "NZD", "1.5")
usd2 = Latinum::Resource.parse("10.00 USD")
nzd = bank.exchange(usd2, "NZD")
puts nzd.to_s               # 15.0 NZD

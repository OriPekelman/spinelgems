# satoshi-unit smoke — constants only (BigDecimal.new removed in Ruby 3.4)
puts Satoshi::UNIT_DENOMINATIONS[:btc]
puts Satoshi::UNIT_DENOMINATIONS[:mbtc]
puts Satoshi::UNIT_DENOMINATIONS[:satoshi]
puts Satoshi::TooManyDigitsAfterDecimalPoint.superclass
puts Satoshi::TooLarge.superclass

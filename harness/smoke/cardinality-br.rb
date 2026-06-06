require 'brazilian_cardinality'

# Number cardinal (Portuguese Brazilian)
puts BrazilianCardinality::Number.number_cardinal(0)
puts BrazilianCardinality::Number.number_cardinal(1)
puts BrazilianCardinality::Number.number_cardinal(15)
puts BrazilianCardinality::Number.number_cardinal(42)
puts BrazilianCardinality::Number.number_cardinal(100)
puts BrazilianCardinality::Number.number_cardinal(101)
puts BrazilianCardinality::Number.number_cardinal(999)
puts BrazilianCardinality::Number.number_cardinal(1000)
puts BrazilianCardinality::Number.number_cardinal(1_500_000)
puts BrazilianCardinality::Number.number_cardinal(-7)
puts BrazilianCardinality::Number.number_cardinal(1_000_000_000)

# Currency cardinal
puts BrazilianCardinality::Currency.currency_cardinal(0)
puts BrazilianCardinality::Currency.currency_cardinal(1)
puts BrazilianCardinality::Currency.currency_cardinal(1.5)
puts BrazilianCardinality::Currency.currency_cardinal(0.99)
puts BrazilianCardinality::Currency.currency_cardinal(1000.01)
puts BrazilianCardinality::Currency.currency_cardinal(-2.50)

# Constants
puts BrazilianCardinality::COUNTRY_CODE
puts BrazilianCardinality::CURRENCY_CODE

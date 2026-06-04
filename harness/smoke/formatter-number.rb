# smoke: formatter-number
# Exercises Formatter::Number#format with integers and floats,
# using default options and custom decimal/grouping/delimiter settings.

require 'formatter/number'

# Default formatter (2 decimals, comma delimiter, dot separator, group-by-3)
f = Formatter::Number.new
puts f.format(100)
puts f.format(10_000)
puts f.format(121_212_123)
puts f.format(10.556)   # rounds to 2dp
puts f.format(10.5)     # no trailing zero when not fixed

# Fixed decimals
f2 = Formatter::Number.new(fixed: true, decimals: 2)
puts f2.format(10.5)    # 10.50

# Custom separator (European style)
f3 = Formatter::Number.new(separator: ',', delimiter: '.')
puts f3.format(10_000)
puts f3.format(10.53)

# Indian grouping (group-by-2)
f4 = Formatter::Number.new(grouping: 2)
puts f4.format(505_000)
puts f4.format(121_212_123)

# Custom delimiter (space)
f5 = Formatter::Number.new(delimiter: ' ')
puts f5.format(7_000_000_000)

# ArgumentError on non-numeric input
begin
  f.format('not a number')
  puts 'no error'
rescue ArgumentError
  puts 'ArgumentError'
end

require 'formatter-number'

# Default formatter: 2 decimals, comma delimiter, dot separator
fmt = Formatter::Number.new
puts fmt.format(1234567)
puts fmt.format(1234567.891)
puts fmt.format(0.5)
puts fmt.format(42)

# Fixed decimal places
fixed = Formatter::Number.new(fixed: true, decimals: 3)
puts fixed.format(3.14159)
puts fixed.format(1000.0)

# European style: dot delimiter, comma separator
euro = Formatter::Number.new(separator: ',', delimiter: '.')
puts euro.format(9876543.21)

# Indian numbering system (grouping: 2)
indian = Formatter::Number.new(grouping: 2)
puts indian.format(1234567)

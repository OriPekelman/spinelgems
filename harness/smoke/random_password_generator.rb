srand(42)
puts RandomPasswordGenerator.generate(8).length
puts RandomPasswordGenerator.generate(8, skip_lower_case: true, skip_upper_case: true, skip_symbols: true).length
p1 = RandomPasswordGenerator.generate(12)
puts p1.length
srand(12345)
puts RandomPasswordGenerator.generate(10)
srand(99)
puts RandomPasswordGenerator.generate(16, skip_symbols: true)

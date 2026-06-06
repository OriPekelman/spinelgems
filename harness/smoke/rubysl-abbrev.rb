require 'rubysl/abbrev'

# Test 1: Abbrev.abbrev with two words sharing a common prefix
result1 = Abbrev.abbrev(['car', 'cone'])
# Sort for deterministic output
result1.sort.each { |k, v| puts "#{k}=>#{v}" }

puts "---"

# Test 2: Abbrev.abbrev with a pattern filter (string prefix)
result2 = Abbrev.abbrev(%w{car box cone}, /b/)
result2.sort.each { |k, v| puts "#{k}=>#{v}" }

puts "---"

# Test 3: Array#abbrev (core extension)
result3 = %w{summer winter}.abbrev
result3.sort.each { |k, v| puts "#{k}=>#{v}" }

puts "---"

# Test 4: words with no shared prefix — every suffix should be unambiguous
result4 = Abbrev.abbrev(%w{alpha beta gamma})
result4.sort.each { |k, v| puts "#{k}=>#{v}" }

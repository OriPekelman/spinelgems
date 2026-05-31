# Smoke: abbrev gem
result = Abbrev.abbrev(%w[car cone])
result.keys.sort.each { |k| puts "#{k}=>#{result[k]}" }

result2 = Abbrev.abbrev(%w[ruby rules])
result2.keys.sort.each { |k| puts "#{k}=>#{result2[k]}" }

puts Abbrev::VERSION

# Test basic retry - first element causes division by zero, second succeeds
result1 = [0, 1, 2].each.retry { |i| 1 / i }
puts result1

# Test retry with all failures returns false
result2 = [1, 2, 3].each.retry { |i| i * 10 }
puts result2

# Test retry where first raises, second element returns
result3 = ["bad", "good"].each.retry { |s| raise ArgumentError if s == "bad"; s.upcase }
puts result3

# Test retry with empty array returns false
result4 = [].each.retry { |i| i }
puts result4.inspect

# Test retry with all errors raises last exception
begin
  ["a", "b"].each.retry { |s| raise RuntimeError, "err-#{s}" }
rescue RuntimeError => e
  puts e.message
end

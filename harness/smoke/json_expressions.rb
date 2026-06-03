require 'json_expressions'
require 'json_expressions/matcher'

# Test 1: basic hash matching (exact match)
pattern = { 'name' => String, 'age' => Integer, 'active' => true }
matcher = JsonExpressions::Matcher.new(pattern)
data = { 'name' => 'Alice', 'age' => 30, 'active' => true }
result = matcher =~ data
puts "basic hash match: #{result}"

# Test 2: hash mismatch — extra key with strict (default)
matcher2 = JsonExpressions::Matcher.new({ 'x' => Integer })
result2 = matcher2 =~ { 'x' => 1, 'y' => 2 }
puts "strict extra key rejected: #{result2 == false}"
puts "last_error: #{matcher2.last_error.include?('extra key')}"

# Test 3: WILDCARD_MATCHER matches anything
wc = JsonExpressions::WILDCARD_MATCHER
puts "wildcard matches string: #{wc == 'hello'}"
puts "wildcard matches nil: #{wc == nil}"
puts "wildcard is_a? String: #{wc.is_a?(String)}"

# Test 4: Symbol captures
pattern4 = { 'id' => :id_cap, 'name' => :name_cap }
matcher4 = JsonExpressions::Matcher.new(pattern4)
result4 = matcher4 =~ { 'id' => 42, 'name' => 'Bob' }
puts "capture match: #{result4}"
puts "captured id: #{matcher4.captures[:id_cap]}"
puts "captured name: #{matcher4.captures[:name_cap]}"

# Test 5: forgiving hash (ignore extra keys)
pattern5 = { 'a' => Integer }.tap { |h| h.ignore_extra_keys! }
matcher5 = JsonExpressions::Matcher.new(pattern5)
result5 = matcher5 =~ { 'a' => 1, 'b' => 2, 'c' => 3 }
puts "forgiving hash match: #{result5}"

# Test 6: ordered array match
pattern6 = [1, 2, 3].tap { |a| a.ordered!.strict! }
matcher6 = JsonExpressions::Matcher.new(pattern6)
puts "ordered array match: #{!!(matcher6 =~ [1, 2, 3])}"
puts "ordered array wrong order: #{matcher6 =~ [3, 2, 1]}"

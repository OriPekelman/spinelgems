require 'lerolero'
require 'tmpdir'

# Run from /tmp so countlerolero.txt writes go there, not polluting the working dir
Dir.chdir(Dir.tmpdir)

# All arrays start with sorted entries and sample from them.
# The arrays always contain the same Portuguese phrases, so structural checks are stable.
# All boolean checks ensure both CRuby and Spinel produce identical output.

# Test 1: no-arg call returns a non-empty string ending with a space
result0 = Lerolero.produzirfraselerolero
puts "no-arg returns String: #{result0.is_a?(String)}"
puts "no-arg non-empty: #{result0.length > 10}"
puts "no-arg ends with space: #{result0.end_with?(' ')}"

# Test 2: with count=2 returns exactly 2 sentences (each ends with '. ')
result2 = Lerolero.produzirfraselerolero(2)
puts "count=2 returns String: #{result2.is_a?(String)}"
dot_space_count = result2.scan(/\.\s/).length
puts "count=2 sentence count: #{dot_space_count}"

# Test 3: with count=1 returns one sentence containing a period
result1 = Lerolero.produzirfraselerolero(1)
puts "count=1 has period: #{result1.include?('.')}"
puts "count=1 ends with space: #{result1.end_with?(' ')}"

# Test 4: count=3 output longer than count=1
r1 = Lerolero.produzirfraselerolero(1)
r3 = Lerolero.produzirfraselerolero(3)
puts "count=3 longer than count=1: #{r3.length > r1.length}"

# Test 5: each generated sentence must contain exactly one period followed by end-of-sentence
# The structure is: prefix + phrase1 + phrase2 + ending(with .)
# Verify output from count=1 matches expected pattern
# (word chars, spaces, and Portuguese chars, ending with '. ')
s = Lerolero.produzirfraselerolero(1)
puts "count=1 matches sentence pattern: #{s =~ /\w.+\.\s*\z/ ? true : false}"

# Test 6: Verify the method only accepts 0 or 1 args (2 args returns nil per case/when)
result_nil = Lerolero.produzirfraselerolero(1, 2)
puts "2-args returns nil: #{result_nil.nil?}"

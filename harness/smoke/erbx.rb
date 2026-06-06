require 'erbx'

# Test 1: basic ERBX.new with default tags {{ }} and (( ))
template1 = ERBX.new("Hello {{ name }}!")
result1 = template1.result_with_hash(name: "World")
puts result1.strip

# Test 2: code block with (( )) and output with {{ }}
template2 = ERBX.new("(( x = 6 * 7 ))The answer is {{ x }}.")
result2 = template2.result
puts result2.strip

# Test 3: multi-line template with conditional logic
src = <<~ERBX
  (( items = ['alpha', 'beta', 'gamma'] ))
  (( items.each do |item| ))
  - {{ item }}
  (( end ))
ERBX
template3 = ERBX.new(src)
puts template3.result.strip

# Test 4: custom tags (code_open/code_close overridden)
template4 = ERBX.new(
  "[[x = 10]]Result: {{ x * 2 }}",
  code_open: '[[',
  code_close: ']]'
)
puts template4.result.strip

# Test 5: verify ERBX.new returns an ERB instance
puts template1.class

# smoke: prettyprint
# Tests PrettyPrint VERSION, format, and singleline_format

puts PrettyPrint::VERSION

# Basic format with short text that fits on one line
result1 = PrettyPrint.format(''.dup, 40) do |q|
  q.group(0, '[', ']') do
    q.text 'hello'
    q.breakable ', '
    q.text 'world'
  end
end
puts result1

# Format that forces a line break (maxwidth=5)
result2 = PrettyPrint.format(''.dup, 5) do |q|
  q.group(2, '[', ']') do
    q.text 'hello'
    q.breakable ', '
    q.text 'world'
  end
end
puts result2.inspect

# singleline_format always avoids breaks
result3 = PrettyPrint.singleline_format(''.dup) do |q|
  q.group(0, '(', ')') do
    q.text 'one'
    q.breakable ' '
    q.text 'two'
    q.breakable ' '
    q.text 'three'
  end
end
puts result3

# Nest indentation check
result4 = PrettyPrint.format(''.dup, 10) do |q|
  q.group(4, '{', '}') do
    q.breakable ''
    q.text 'abc'
    q.breakable ''
    q.text 'def'
  end
end
puts result4.inspect

# smoke: static_literal_parser
# Tests StaticLiteralParser.parse with simple literals

result1 = StaticLiteralParser.parse("42", {})
puts result1.inspect

result2 = StaticLiteralParser.parse('"hello"', {})
puts result2.inspect

result3 = StaticLiteralParser.parse("[1, 2, 3]", {})
puts result3.inspect

result4 = StaticLiteralParser.parse("{a: 1, b: 2}", {})
puts result4.inspect

result5 = StaticLiteralParser.parse("true", {})
puts result5.inspect

result6 = StaticLiteralParser.parse("nil", {})
puts result6.inspect

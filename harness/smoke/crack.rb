require 'crack'

# Exercise Crack::JSON.parse with a simple object
result = Crack::JSON.parse('{"name":"Alice","age":30}')
puts result["name"]
puts result["age"]

# Nested JSON object
nested = Crack::JSON.parse('{"user":{"id":1,"active":true}}')
puts nested["user"]["id"]
puts nested["user"]["active"]

# JSON array
arr = Crack::JSON.parse('[1,2,3]')
puts arr.inspect

# Exercise Crack::XML.parse with a simple element
xml_result = Crack::XML.parse('<root><name>Bob</name><count>5</count></root>')
puts xml_result["root"]["name"]
puts xml_result["root"]["count"]

# XML with typed attributes
xml_typed = Crack::XML.parse('<items type="array"><item>one</item><item>two</item></items>')
puts xml_typed["items"].inspect

# Exercise Crack::Util.snake_case
puts Crack::Util.snake_case("HelloWorld")
puts Crack::Util.snake_case("XMLParser")
puts Crack::Util.snake_case("simpleTest")

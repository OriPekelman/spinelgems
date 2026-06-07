# frozen_string_literal: true

require 'modl'

# 1. Simple key=value parse
result = MODL.parse('name=Alice')
puts result.inspect
# => {"name"=>"Alice"}

# 2. Multiple key=value pairs separated by semicolon
result2 = MODL.parse('x=1;y=2;z=3')
puts result2['x']
puts result2['y']
puts result2['z']

# 3. Parse to JSON string
json = MODL::Interpreter.interpret_to_json_string('greeting=hello;count=42')
puts json

# 4. Nested map syntax
result3 = MODL.parse('person=(name=Bob;age=30)')
puts result3['person']['name']
puts result3['person']['age']

# 5. Array syntax
result4 = MODL.parse('colors=[red;green;blue]')
puts result4['colors'].inspect

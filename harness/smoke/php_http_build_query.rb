require 'php_http_build_query'

# Simple flat hash
result1 = PHP.http_build_query({'b' => 'two', 'a' => 'one', 'c' => 'three'})
puts result1

# Hash with numeric values
result2 = PHP.http_build_query({'foo' => 42, 'bar' => 99})
puts result2

# Nested hash
result3 = PHP.http_build_query({'user' => {'name' => 'Alice', 'age' => '30'}})
puts result3

# Array input
result4 = PHP.http_build_query(['hello', 'world'])
puts result4

# Special characters (CGI-escaped)
result5 = PHP.http_build_query({'q' => 'hello world', 'lang' => 'ruby+spinel'})
puts result5

# hashify directly on a scalar with parent key
h = PHP.hashify('scalar_value', 'mykey')
puts h.inspect

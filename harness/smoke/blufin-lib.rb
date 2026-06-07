require 'blufin-lib'

# Blufin::Strings — snake_case / camelCase conversions
puts Blufin::Strings.snake_case_to_camel_case('hello_world')       # HelloWorld
puts Blufin::Strings.snake_case_to_camel_case('foo_bar_baz')       # FooBarBaz
puts Blufin::Strings.snake_case_to_camel_case_lower('hello_world') # helloWorld
puts Blufin::Strings.camel_case_to_snake_case('HelloWorld')        # hello_world
puts Blufin::Strings.camel_case_to_snake_case('FooBarBaz')         # foo_bar_baz

# Blufin::Strings — remove surrounding slashes
puts Blufin::Strings.remove_surrounding_slashes('/some/path/')      # some/path
puts Blufin::Strings.remove_surrounding_slashes('  /a/b/c/  ')     # a/b/c

# Blufin::Strings — strip helpers
puts Blufin::Strings.strip_newline("hello\nworld\n")               # helloworld
puts Blufin::Strings.strip_ansi_colors("\e[31mred\e[0m text")      # red text

# Blufin::Strings — string difference percent (deterministic pure logic)
puts Blufin::Strings.string_difference_percent('hello', 'hello')   # 0
puts Blufin::Strings.string_difference_percent('hello', 'world')   # some non-zero integer

# Blufin::Arrays — duplicate detection
puts Blufin::Arrays.array_has_duplicate(['a', 'b', 'c']).inspect             # false
puts Blufin::Arrays.array_has_duplicate(['a', 'b', 'a']).inspect             # true
puts Blufin::Arrays.array_has_duplicate(['A', 'a'], true).inspect            # true (ignore_case)

# Blufin::Arrays — line array / string round-trip
arr = ['line one', 'line two', 'line three']
str = Blufin::Arrays.convert_line_array_to_string(arr)
puts str
back = Blufin::Arrays.convert_string_to_line_array(str)
puts back.inspect

# Blufin::Numbers — comma formatting
puts Blufin::Numbers.add_commas(1234567)     # 1,234,567
puts Blufin::Numbers.add_commas(1000)        # 1,000
puts Blufin::Numbers.add_commas(999)         # 999
puts Blufin::Numbers.add_commas(1234567.89)  # 1,234,567.89

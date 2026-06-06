require 'string-cases'

# snake_to_camel
puts StringCases.snake_to_camel("hello_world")          # HelloWorld
puts StringCases.snake_to_camel("foo_bar_baz")           # FooBarBaz
puts StringCases.snake_to_camel("simple")                # Simple

# camel_to_snake
puts StringCases.camel_to_snake("HelloWorld")            # hello_world
puts StringCases.camel_to_snake("FooBarBaz")             # foo_bar_baz
puts StringCases.camel_to_snake("Simple")                # simple

# pluralize
puts StringCases.pluralize("cat")                        # cats
puts StringCases.pluralize("city")                       # cities
puts StringCases.pluralize("query")                      # queries
puts StringCases.pluralize("dog")                        # dogs

# singularize
puts StringCases.singularize("cats")                     # cat
puts StringCases.singularize("cities")                   # city
puts StringCases.singularize("dogs")                     # dog

# symbolize_keys and stringify_keys
h = {"a" => 1, "b" => 2}
sym = StringCases.symbolize_keys(h)
puts sym[:a]                                             # 1
puts sym[:b]                                             # 2

h2 = {a: 10, b: 20}
str = StringCases.stringify_keys(h2)
puts str["a"]                                            # 10
puts str["b"]                                            # 20

# recursive symbolize_keys
nested = {"x" => {"y" => 99}}
result = StringCases.symbolize_keys(nested, recursive: true)
puts result[:x][:y]                                      # 99

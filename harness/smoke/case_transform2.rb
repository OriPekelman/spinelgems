# frozen_string_literal: true

require 'case_transform2'

# Test camel (UpperCamelCase)
puts CaseTransform2.camel("some_key")           # => SomeKey
puts CaseTransform2.camel("hello_world_foo")    # => HelloWorldFoo
puts CaseTransform2.camel(:my_symbol).inspect   # => :MySymbol

# Test camel_lower (camelCase)
puts CaseTransform2.camel_lower("some_key")     # => someKey
puts CaseTransform2.camel_lower("hello_world")  # => helloWorld

# Test dash (dashed-case)
puts CaseTransform2.dash("some_key")            # => some-key
puts CaseTransform2.dash("hello_world_foo")     # => hello-world-foo

# Test underscore (underscore_case)
puts CaseTransform2.underscore("SomeKey")       # => some_key
puts CaseTransform2.underscore("HelloWorldFoo") # => hello_world_foo
puts CaseTransform2.underscore("some-key")      # => some_key

# Test with array
arr = CaseTransform2.camel(["some_key", "hello_world"])
puts arr.inspect  # => ["SomeKey", "HelloWorld"]

# Test with hash
hash = CaseTransform2.camel({ "some_key" => 1, "hello_world" => 2 })
puts hash.keys.sort.inspect  # => ["HelloWorld", "SomeKey"]

# Test unaltered
puts CaseTransform2.unaltered("unchanged").inspect  # => "unchanged"

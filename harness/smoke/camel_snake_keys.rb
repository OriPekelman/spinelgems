# smoke: camel_snake_keys — pure string/hash key conversion, no external deps
puts CamelSnakeKeys.camelcase("hello_world")
puts CamelSnakeKeys.camelcase("foo_bar_baz")
puts CamelSnakeKeys.snakecase("helloWorld")
puts CamelSnakeKeys.snakecase("FooBarBaz")
puts CamelSnakeKeys.snake_keys({"helloWorld" => 1, "fooBar" => 2}).inspect
puts CamelSnakeKeys.camel_keys({"hello_world" => 1, "foo_bar" => 2}).inspect
puts CamelSnakeKeys.snake_keys([{"camelCase" => "val"}]).inspect
puts CamelSnakeKeys.camelcase("already_done")
puts CamelSnakeKeys.snakecase("alreadyDone")

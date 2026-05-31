# Smoke test for sewell - Groonga query builder
# Using Sewell.generate with string input
puts Sewell.generate("hello world", ["title", "body"])
puts Sewell.generate("foo OR bar", ["name"])
puts Sewell.generate("test -exclude", ["title"])
puts Sewell.generate({"title" => "ruby rails"}, "AND")
puts Sewell.generate({"author" => "smith jones"}, "OR")

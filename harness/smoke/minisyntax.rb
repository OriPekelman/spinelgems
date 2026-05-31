# highlight with unknown symbol lang returns code unchanged
puts MiniSyntax.highlight("hello world", :nolang)

# highlight with unknown symbol lang (another case)
puts MiniSyntax.highlight("foo = 1", :unknown)

# register a trivial custom highlighter and call it
module TrivialHL
  def self.highlight(code)
    "WRAP:#{code}"
  end
end
MiniSyntax.register(:trivial, TrivialHL)
puts MiniSyntax.highlight("bar", :trivial)

# string-based multi-lang split falls through when no handlers registered for those langs
puts MiniSyntax.highlight("test", "nolang")

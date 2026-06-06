require 'whittle'

# Whittle: pure-Ruby LALR(1) parser without code generation.
# Build a simple integer arithmetic parser that exercises:
#   - Whittle::Parser subclass with terminal + non-terminal rules
#   - operator precedence (% :left ^ N)
#   - recursive grammar rules (rule(:expr) { ... })
#   - parse table generation (lazy, on first parse)
#   - the #parse instance method returning a computed value

class IntCalc < Whittle::Parser
  rule(:wsp => /\s+/).skip!

  rule(:int => /[0-9]+/).as { |n| n.to_i }

  rule("+") % :left ^ 1
  rule("-") % :left ^ 1
  rule("*") % :left ^ 2
  rule("/") % :left ^ 2

  rule("(")
  rule(")")

  rule(:expr) do |r|
    r["(", :expr, ")"].as { |_, e, _| e }
    r[:expr, "+", :expr].as { |a, _, b| a + b }
    r[:expr, "-", :expr].as { |a, _, b| a - b }
    r[:expr, "*", :expr].as { |a, _, b| a * b }
    r[:expr, "/", :expr].as { |a, _, b| a / b }
    r[:int]
  end

  start(:expr)
end

calc = IntCalc.new

# Basic arithmetic
puts calc.parse("3 + 4")           # => 7
puts calc.parse("10 - 3")          # => 7
puts calc.parse("6 * 7")           # => 42

# Operator precedence: * binds tighter than +
puts calc.parse("2 + 3 * 4")       # => 14 (not 20)

# Left-associativity: 10 - 3 - 2 => (10-3)-2 = 5
puts calc.parse("10 - 3 - 2")      # => 5

# Parentheses override precedence
puts calc.parse("(2 + 3) * 4")     # => 20

# Multi-operation
puts calc.parse("100 / 4 + 3 * 5") # => 40

# Version constant
puts Whittle::VERSION               # => 0.0.8

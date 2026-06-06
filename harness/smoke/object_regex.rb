require 'object_regex'

# ObjectRegex applies regex-like patterns to sequences of objects.
# Each object must implement #reg_desc (returns a token string).

# Simple token class
Token = Struct.new(:type) do
  def reg_desc
    type
  end
end

# Build a sequence of tokens
tokens = [
  Token.new('NUM'),
  Token.new('PLUS'),
  Token.new('NUM'),
  Token.new('STAR'),
  Token.new('NUM'),
  Token.new('SEMI'),
]

# Match a single NUM
r1 = ObjectRegex.new('NUM')
m1 = r1.match(tokens)
puts m1.map(&:type).inspect

# Match NUM PLUS NUM pattern
r2 = ObjectRegex.new('NUM PLUS NUM')
m2 = r2.match(tokens)
puts m2.map(&:type).inspect

# all_matches: find every NUM in the sequence
r3 = ObjectRegex.new('NUM')
all = r3.all_matches(tokens)
puts all.length
puts all.map { |m| m.map(&:type).inspect }.inspect

# mapped_value: check token mapping for known token
puts r1.mapped_value('NUM').end_with?(';')
puts r1.mapped_value('UNKNOWN').end_with?(';')

# Pattern with alternation using object_regex range syntax [A B]
r4 = ObjectRegex.new('[NUM PLUS]+')
m4 = r4.match(tokens)
puts m4.map(&:type).inspect

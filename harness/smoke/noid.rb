require 'noid'

# 1. Template parsing: prefix, generator, characters
t = Noid::Template.new('fk4.reeedk')
puts t.prefix       # => "fk4"
puts t.generator    # => "r"
puts t.characters   # => "eeedd" (mask chars after generator)

# 2. Sequential minting with a known template — deterministic output
seq_minter = Noid::Minter.new(template: '.sdd')
5.times { puts seq_minter.mint }

# 3. Template#max — total identifier space
t2 = Noid::Template.new('.sddk')
puts t2.max   # => 100

# 4. Template#valid? — roundtrip: mint then validate
t3 = Noid::Template.new('.seddk')
m = Noid::Minter.new(template: '.seddk')
id = m.mint
puts id
puts t3.valid?(id)   # => true
puts t3.valid?('xxxx') # => false

# 5. Minter#remaining decrements as we mint
m2 = Noid::Minter.new(template: '.sdd')
before = m2.remaining
m2.mint
after = m2.remaining
puts before - after  # => 1

# 6. Minter#valid? delegates to template
m3 = Noid::Minter.new(template: '.seddk')
puts m3.valid?(id)   # => true

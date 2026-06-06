require 'character_enumerator'

# integer_to_characters: 0-based index -> spreadsheet column name
puts CharacterEnumerator.integer_to_characters(0)   # A
puts CharacterEnumerator.integer_to_characters(25)  # Z
puts CharacterEnumerator.integer_to_characters(26)  # AA
puts CharacterEnumerator.integer_to_characters(701) # ZZ

# characters_to_integer: reverse mapping
puts CharacterEnumerator.characters_to_integer("A")   # 0
puts CharacterEnumerator.characters_to_integer("Z")   # 25
puts CharacterEnumerator.characters_to_integer("AA")  # 26
puts CharacterEnumerator.characters_to_integer("ZZ")  # 701

# blank/nil string should return nil
puts CharacterEnumerator.characters_to_integer("   ").inspect  # nil

# generate returns an enumerator; take first 5 labels
gen = CharacterEnumerator.generate(5)
puts gen.to_a.join(",")  # A,B,C,D,E

# round-trip check: integer_to_characters(characters_to_integer(x)) == x
%w[A Z AA AZ BA ZZ].each do |label|
  idx = CharacterEnumerator.characters_to_integer(label)
  back = CharacterEnumerator.integer_to_characters(idx)
  puts "#{label}->#{idx}->#{back}"
end

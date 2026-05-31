# Test the SAFE_ALPHABET constant and its properties
puts Nanoid::SAFE_ALPHABET.length
puts Nanoid::SAFE_ALPHABET[0]
puts Nanoid::SAFE_ALPHABET[-1]
puts Nanoid::SAFE_ALPHABET.include?('a')
puts Nanoid::SAFE_ALPHABET.include?('!')
puts Nanoid::SAFE_ALPHABET.chars.sort.first

# frozen_string_literal: true

require 'rambling-trie'

# Build a trie from a set of words
trie = Rambling::Trie.create

words = %w[car care careful carefully cart carbon]
words.each { |w| trie << w }

# word? — exact match
puts trie.word?('car')        # true
puts trie.word?('ca')         # false
puts trie.word?('careful')    # true

# partial_word? — prefix match
puts trie.partial_word?('care')  # true
puts trie.partial_word?('xyz')   # false

# include? is alias for word?
puts trie.include?('cart')    # true
puts trie.include?('carb')    # false

# match? is alias for partial_word?
puts trie.match?('carb')      # true

# scan / words — all words starting with prefix
scanned = trie.scan('care').sort
puts scanned.inspect

# size — number of entries in root's children tree
puts trie.size

# compress! and verify words still found
trie.compress!
puts trie.compressed?         # true
puts trie.word?('carefully')  # true
puts trie.word?('carb')       # false
puts trie.partial_word?('car') # true

# words_within — find trie words embedded in a phrase
trie2 = Rambling::Trie.create
%w[cat at a].each { |w| trie2 << w }
within = trie2.words_within('concatenate').sort.uniq
puts within.inspect

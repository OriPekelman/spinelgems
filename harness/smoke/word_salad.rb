# frozen_string_literal: true

require 'word_salad'

# WordSalad.size — total words in the dictionary
puts WordSalad.size

# WordSalad.words — returns array of all words
all = WordSalad.words
puts all.length
puts all.first
puts all.last

# Integer#words — fixed count, seeded for reproducibility
srand(42)
picked = 5.words
puts picked.length
puts picked.all? { |w| w.is_a?(String) && !w.empty? }

# Integer#sentence with variance:false — deterministic length
srand(42)
s = 6.sentence(6, variance: false)
puts s.end_with?('.')
# sentence should have 6 words
puts s.split(' ').length

# Integer#sentences — returns array of sentences
srand(42)
ss = 3.sentences(4, variance: false)
puts ss.length
puts ss.all? { |x| x.end_with?('.') }

# Integer#paragraph — joins sentences into one string
srand(42)
p_text = 2.paragraph(3, 4, variance: false)
puts p_text.include?(' ')
puts p_text.end_with?('.')

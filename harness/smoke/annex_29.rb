# frozen_string_literal: true
# Smoke test for annex_29 — Unicode Annex #29 word segmentation

require 'annex_29'

# Test 1: basic ASCII word segmentation
words1 = Annex29.segment_words("Hello, world!")
puts "ASCII segments: #{words1.inspect}"

# Test 2: words with punctuation - should split on word boundaries
words2 = Annex29.segment_words("foo bar baz")
puts "Space-separated count: #{words2.length}"
puts "Space-separated words: #{words2.inspect}"

# Test 3: empty string
words3 = Annex29.segment_words("")
puts "Empty string segments: #{words3.inspect}"

# Test 4: numbers and mixed content
words4 = Annex29.segment_words("abc123def")
puts "Mixed alphanum segments: #{words4.inspect}"

# Test 5: Unicode text (Japanese / CJK - each character is its own word boundary)
words5 = Annex29.segment_words("caté")
puts "Accented char segment count: #{words5.length}"

# Test 6: segment count for a known sentence
sentence = "The quick brown fox."
words6 = Annex29.segment_words(sentence)
puts "Sentence segment count: #{words6.length}"
puts "Sentence first segment: #{words6.first.inspect}"

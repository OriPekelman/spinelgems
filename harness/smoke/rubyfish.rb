require 'rubyfish'

# Hamming distance: counts positions where characters differ (pads shorter)
h1 = RubyFish::Hamming.distance("karolin", "kathrin")
h2 = RubyFish::Hamming.distance("abc", "abc")
h3 = RubyFish::Hamming.distance("Hello", "World")
puts "hamming karolin/kathrin: #{h1}"
puts "hamming abc/abc: #{h2}"
puts "hamming Hello/World: #{h3}"

# Levenshtein distance
l1 = RubyFish::Levenshtein.distance("kitten", "sitting")
l2 = RubyFish::Levenshtein.distance("", "abc")
l3 = RubyFish::Levenshtein.distance("saturday", "sunday")
puts "levenshtein kitten/sitting: #{l1}"
puts "levenshtein empty/abc: #{l2}"
puts "levenshtein saturday/sunday: #{l3}"

# Damerau-Levenshtein distance (allows transpositions)
d1 = RubyFish::DamerauLevenshtein.distance("ca", "abc")
d2 = RubyFish::DamerauLevenshtein.distance("kitten", "sitting")
puts "damerau ca/abc: #{d1}"
puts "damerau kitten/sitting: #{d2}"

# Jaro-Winkler distance (similarity, higher = more similar)
jw1 = RubyFish::JaroWinkler.distance("MARTHA", "MARHTA")
jw2 = RubyFish::JaroWinkler.distance("hello", "world")
jw3 = RubyFish::JaroWinkler.distance("", "")
puts "jaro_winkler MARTHA/MARHTA: #{jw1.round(4)}"
puts "jaro_winkler hello/world: #{jw2.round(4)}"
puts "jaro_winkler empty/empty: #{jw3}"

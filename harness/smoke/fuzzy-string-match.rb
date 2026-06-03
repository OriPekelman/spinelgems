require 'fuzzystringmatch'

# Create a pure-Ruby Jaro-Winkler distance calculator (avoids C extension)
jw = FuzzyStringMatch::JaroWinkler.create(:pure)

puts jw.pure?

# Classic Jaro-Winkler string distance examples
puts jw.getDistance("martha", "marhta").round(4)
puts jw.getDistance("jones", "johnson").round(4)
puts jw.getDistance("abc", "abc").round(4)
puts jw.getDistance("abc", "xyz").round(4)
puts jw.getDistance("JELLYFISH", "SMELLYFISH").round(4)
puts jw.getDistance("hello", "world").round(4)

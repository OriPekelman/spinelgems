require_relative "lib/fuzzystringmatch"
jw = FuzzyStringMatch::JaroWinkler.create(:pure)
puts jw.pure?
puts jw.getDistance("martha", "marhta").round(4)
puts jw.getDistance("jones", "johnson").round(4)
puts jw.getDistance("abc", "abc").round(4)
puts jw.getDistance("abc", "xyz").round(4)
puts jw.getDistance("hello", "").round(4)
puts jw.getDistance("", "").round(4)

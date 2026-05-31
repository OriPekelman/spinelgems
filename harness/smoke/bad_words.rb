# Drive BadWords.clean_string and BadWords.verify_string directly
# (avoids YAML/load_words; both methods are pure string logic)

bad = ["hell", "damn", "crap"]

puts BadWords.clean_string("This is hell on earth", bad)
puts BadWords.clean_string("Hello world no bad words here", bad)
puts BadWords.clean_string("damn that crap is bad", bad)

puts BadWords.verify_string("This is hell on earth", bad)
puts BadWords.verify_string("Hello world no bad words here", bad)
puts BadWords.verify_string("damn that crap is bad", bad)

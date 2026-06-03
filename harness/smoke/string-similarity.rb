require 'string-similarity'

# Levenshtein distance
puts String::Similarity.levenshtein_distance('kitten', 'sitting')
puts String::Similarity.levenshtein_distance('abc', 'abc')
puts String::Similarity.levenshtein_distance('', 'hello')

# Levenshtein similarity (inversion of distance)
puts String::Similarity.levenshtein('abc', 'abc').round(4)
puts String::Similarity.levenshtein('cat', 'bat').round(4)
puts String::Similarity.levenshtein('', 'hello').round(4)

# Cosine similarity
puts String::Similarity.cosine('hello world', 'hello world').round(4)
puts String::Similarity.cosine('hello', 'world').round(4)
puts String::Similarity.cosine('', 'hello').round(4)
puts String::Similarity.cosine('abc', 'xyz').round(4)

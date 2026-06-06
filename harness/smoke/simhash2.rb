require 'simhash2'

# generate: produce a simhash fingerprint from a string
h1 = Simhash.generate("the quick brown fox jumps over the lazy dog")
h2 = Simhash.generate("the quick brown fox jumps over the lazy cat")
h3 = Simhash.generate("completely different text with no overlap whatsoever")

puts "hash1=#{h1}"
puts "hash2=#{h2}"
puts "hash3=#{h3}"

# hamming_distance: count differing bits between two simhashes
d12 = Simhash.hamming_distance(h1, h2)
d13 = Simhash.hamming_distance(h1, h3)
puts "hamming(h1,h2)=#{d12}"
puts "hamming(h1,h3)=#{d13}"

# similar strings should have smaller hamming distance than dissimilar ones
puts "near_pair_closer=#{d12 < d13}"

# hash_similarity: returns a float in [0,1]
sim12 = Simhash.hash_similarity(h1, h2)
sim13 = Simhash.hash_similarity(h1, h3)
puts "sim(h1,h2)=#{sim12.round(4)}"
puts "sim(h1,h3)=#{sim13.round(4)}"
puts "similar_gt_dissimilar=#{sim12 > sim13}"

# similarity: end-to-end convenience method
s = Simhash.similarity("hello world foo bar", "hello world foo baz")
puts "similarity_result=#{s.round(4)}"

# generate_from_tokens: explicit token list
tokens = ["ruby", "programming", "language", "compiled"]
ht = Simhash.generate_from_tokens(tokens)
puts "token_hash=#{ht}"

# with unique:true the duplicate tokens should not affect the hash
tokens_dup = ["ruby", "ruby", "programming", "language", "compiled"]
ht_uniq = Simhash.generate_from_tokens(tokens_dup.dup, unique: true)
puts "token_hash_unique=#{ht_uniq}"
puts "unique_matches_deduped=#{ht == ht_uniq}"

# stop_words option
tokens_stop = ["the", "quick", "fox"]
ht_stop = Simhash.generate_from_tokens(tokens_stop.dup, stop_words: ["the"])
ht_nostop = Simhash.generate_from_tokens(["quick", "fox"])
puts "stop_words_match=#{ht_stop == ht_nostop}"

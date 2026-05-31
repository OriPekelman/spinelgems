f = Stopwords::Filter.new(["the", "a", "an", "is", "in"])
words = ["the", "quick", "brown", "fox", "is", "in", "a", "forest"]
puts f.filter(words).join(", ")
puts f.stopword?("the")
puts f.stopword?("fox")
puts f.stopword?("THE")
puts f.stopwords.sort.join(", ")
puts f.filter([]).inspect

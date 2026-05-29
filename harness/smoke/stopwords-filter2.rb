require_relative "lib/stopwords"

sw = ["the", "a", "an", "is", "it"]
f = Stopwords::Filter.new(sw)

puts f.stopwords.sort.inspect
puts f.stopword?("the")
puts f.stopword?("ruby")
puts f.stopword?("THE")
puts f.filter(["the", "quick", "brown", "fox", "is", "fast"]).inspect
puts f.filter([]).inspect

require 'naivebayes'

# Multinomial Naive Bayes classifier smoke
# Train a simple spam/ham classifier
clf = NaiveBayes::Classifier.new

clf.train("spam", {"buy" => 3, "cheap" => 2, "now" => 1})
clf.train("spam", {"buy" => 1, "discount" => 2, "free" => 3})
clf.train("ham",  {"hello" => 2, "friend" => 1, "lunch" => 1})
clf.train("ham",  {"meeting" => 2, "tomorrow" => 1, "hello" => 1})

puts "total_count: #{clf.total_count}"
puts "labels: #{clf.instance_count_of.keys.sort.join(', ')}"

# Classify a spam-like message
result_spam = clf.classify({"buy" => 2, "cheap" => 1, "free" => 1})
# Determine which class has higher posterior
best_spam = result_spam.max_by { |_k, v| v }[0]
puts "spam-like classified as: #{best_spam}"

# Classify a ham-like message
result_ham = clf.classify({"hello" => 1, "friend" => 1, "meeting" => 1})
best_ham = result_ham.max_by { |_k, v| v }[0]
puts "ham-like classified as: #{best_ham}"

# Posteriors are probabilities summing to ~1 for MNB
sum = result_spam.values.inject(0.0) { |s, v| s + v }
puts "posterior sum ~1: #{(sum - 1.0).abs < 0.001}"

# Complement NB classifier
clf2 = NaiveBayes::Classifier.new(model: "complement")
clf2.train("pos", {"great" => 2, "love" => 1, "awesome" => 1})
clf2.train("pos", {"good" => 2, "nice" => 1})
clf2.train("neg", {"bad" => 2, "terrible" => 1, "awful" => 1})
clf2.train("neg", {"poor" => 1, "worst" => 2})

result_pos = clf2.classify({"great" => 1, "love" => 1})
best_pos = result_pos.max_by { |_k, v| v }[0]
puts "pos-like classified as: #{best_pos}"

result_neg = clf2.classify({"bad" => 2, "terrible" => 1})
best_neg = result_neg.max_by { |_k, v| v }[0]
puts "neg-like classified as: #{best_neg}"

puts "done"

data = ["the cat sat on the mat", "the cat is fat"]
ng = NGram.new(data, n: 2)

all = ng.ngrams_of_all_data
puts all[2]["the cat"]
puts all[2]["cat sat"]
puts all[2]["cat is"]

inputs = ng.ngrams_of_inputs
puts inputs[0][2]["the cat"]
puts inputs[1][2]["the cat"]

ng2 = NGram.new(["one two three"], n: [1, 2])
a2 = ng2.ngrams_of_all_data
puts a2[1]["one"]
puts a2[1]["two"]
puts a2[2]["two three"]

require 'decisiontree'

# === Array#entropy smoke ===
puts "entropy([])=#{[].entropy}"
puts "entropy([1,1])=#{[1,1].entropy.round(4)}"
arr = ['A','A','B','B','B']
puts "entropy(mixed)=#{arr.entropy.round(4)}"

# === Discrete classification: weather => play tennis ===
attributes = ['outlook', 'humidity', 'wind']
training = [
  ['sunny',    'high',   'weak',   'no'],
  ['sunny',    'high',   'strong', 'no'],
  ['overcast', 'high',   'weak',   'yes'],
  ['rainy',    'normal', 'weak',   'yes'],
  ['rainy',    'normal', 'strong', 'no'],
  ['overcast', 'normal', 'strong', 'yes'],
  ['sunny',    'normal', 'weak',   'yes'],
  ['rainy',    'high',   'weak',   'yes'],
]

tree = DecisionTree::ID3Tree.new(attributes, training, 'no', :discrete)
tree.train

# Predict a few test cases
t1 = tree.predict(['sunny', 'normal', 'weak'])
t2 = tree.predict(['rainy', 'high', 'strong'])
t3 = tree.predict(['overcast', 'high', 'strong'])

puts "predict(sunny,normal,weak)=#{t1}"
puts "predict(rainy,high,strong)=#{t2}"
puts "predict(overcast,high,strong)=#{t3}"

# === Continuous classification: temperature => fever ===
cont_attrs = ['temperature']
cont_data = [
  [36.0, 'healthy'],
  [36.5, 'healthy'],
  [37.5, 'sick'],
  [38.0, 'sick'],
  [38.5, 'sick'],
  [39.0, 'sick'],
]

ctree = DecisionTree::ID3Tree.new(cont_attrs, cont_data, 'healthy', :continuous)
ctree.train

puts "predict([36.0])=#{ctree.predict([36.0])}"
puts "predict([39.0])=#{ctree.predict([39.0])}"

# === Node struct ===
n = DecisionTree::Node.new('outlook', nil, 0.5)
puts "node=#{n.attribute},#{n.gain}"

puts "done"

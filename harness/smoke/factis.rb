require 'factis'

# Exercise Factis::Memory directly
Factis::Memory.memorize(:name, 'Alice')
Factis::Memory.memorize(:age, 30)
Factis::Memory.memorize(:city, 'Berlin')

puts Factis::Memory.recall(:name)
puts Factis::Memory.recall(:age)
puts Factis::Memory.known_fact?(:city)
puts Factis::Memory.known_fact?(:country)

# all_facts
facts = Factis::Memory.all_facts
puts facts.keys.sort.inspect

# forget a fact
Factis::Memory.forget(:city)
puts Factis::Memory.known_fact?(:city)

# overwrite via memorize with option
Factis::Memory.memorize(:age, 31, overwrite: true)
puts Factis::Memory.recall(:age)

# reset
Factis::Memory.reset!
puts Factis::Memory.all_facts.empty?

# Exercise through the Factis module mixin
obj = Object.new
obj.extend(Factis)
obj.memorize_fact(:color, 'red')
obj.memorize_fact(:shape, 'circle')
puts obj.recall_fact(:color)
puts obj.all_facts.keys.sort.inspect
obj.forget_fact(:shape)
puts obj.all_facts.length

# indifferently_memorize_fact allows overwrite
obj.indifferently_memorize_fact(:color, 'blue')
puts obj.recall_fact(:color)

# error on duplicate memorize
begin
  obj.memorize_fact(:color, 'green')
rescue RuntimeError => e
  puts e.message[0, 40]
end

obj.clear_all_facts!
puts obj.all_facts.empty?

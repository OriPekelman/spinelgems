result = Kappamaki.from_sentence('Alice, Bob and Carol')
puts result.inspect

result2 = Kappamaki.from_sentence('one and two and three')
puts result2.inspect

attrs = Kappamaki.attributes_from_sentence('name: "Alice", age: "30" and role: "admin"')
puts attrs[:name]
puts attrs[:age]
puts attrs[:role]

h = Kappamaki.symbolize_keys_deep!({"a" => {"b" => 1}})
puts h.keys.first.inspect
puts h[:a].keys.first.inspect

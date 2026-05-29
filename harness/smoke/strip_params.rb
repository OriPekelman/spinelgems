h = { name: "  hello  ", age: "  42  " }
StripParams.all!(h)
puts h[:name]
puts h[:age]

nested = { a: { b: "  world  " }, c: "  foo  " }
StripParams.all!(nested)
puts nested[:a][:b]
puts nested[:c]

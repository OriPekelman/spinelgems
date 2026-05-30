# StrongStruct smoke — exercises anonymous struct creation, accessors, attributes

Person = StrongStruct.new("Person", :name, :age)

p = Person.new(name: "Alice", age: 30)
puts p.name
puts p.age

attrs = p.attributes
puts attrs["name"]
puts attrs["age"]

p.name = "Bob"
puts p.name

# anonymous struct
Anon = StrongStruct.new(:x, :y)
a = Anon.new(x: 1, y: 2)
puts a.x
puts a.y

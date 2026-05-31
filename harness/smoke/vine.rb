h = { "name" => "Alice", "address" => { "city" => "Paris" }, :score => 42 }
puts h.access("name")
puts h.access("address.city")
puts h.access("score").inspect

h2 = {}
h2.set("user.name", "Bob")
puts h2.inspect

h3 = { "a" => 1, "b" => 2 }
h3.set("c", 99)
puts h3.access("c")

arr = [1, 2, 3, 4]
puts arr.segmentation(2).length
puts arr.segmentation(3).length

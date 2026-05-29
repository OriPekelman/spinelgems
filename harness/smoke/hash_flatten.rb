using HashFlatten

h = { "a" => { "b" => 1, "c" => 2 }, "d" => 3 }
flat = h.squish_levels
puts flat["a.b"]
puts flat["a.c"]
puts flat["d"]

h2 = { "a.b" => 1, "a.c" => 2, "d" => 3 }
nested = h2.stretch_to_levels
puts nested["a"].class
puts nested["a"]["b"]
puts nested["d"]

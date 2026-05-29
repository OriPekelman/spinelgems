# KeyFlatten API smoke — no external deps needed
h = { "a" => { "b" => { "c" => 1 }, "d" => 2 }, "e" => 3 }
flat = KeyFlatten.key_flatten(h)
flat.sort.each { |k, v| puts "#{k}=#{v}" }

h2 = { "x.y.z" => 10, "x.y.w" => 20, "x.q" => 30 }
unflat = KeyFlatten.key_unflatten(h2)
puts unflat["x"]["y"]["z"]
puts unflat["x"]["y"]["w"]
puts unflat["x"]["q"]

flat2 = KeyFlatten.key_flatten({ "a" => { "b" => 99 } }, delimiter: "-")
flat2.sort.each { |k, v| puts "#{k}=#{v}" }

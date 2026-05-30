r = Revolver.new(3)
r << 1 << 2 << 3 << 4
puts r.to_a.inspect
puts r.size
puts r[0]
puts r[1]
puts r[2]

r2 = Revolver.from_array([10, 20, 30, 40], unique: false)
puts r2.to_a.inspect
puts r2.unique?

r3 = Revolver.new(3, unique: true)
r3 << 5 << 6 << 5
puts r3.to_a.inspect

r4 = Revolver[100, 200, 300]
puts r4.to_a.inspect
puts r4.to_s

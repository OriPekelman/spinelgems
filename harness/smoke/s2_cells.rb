require 's2_cells'

# S2LatLon -> S2CellId at various levels
ll = S2Cells::S2LatLon.new(37.7749, -122.4194)  # San Francisco

level12 = ll.to_s2_id(12)
level20 = ll.to_s2_id(20)
level30 = ll.to_s2_id(30)

puts "level 12: #{level12}"
puts "level 20: #{level20}"
puts "level 30: #{level30}"

# S2Point directly
p = S2Cells::S2Point.new(1.0, 0.5, 0.25)
puts "largest_abs: #{p.largest_abs_component}"
puts "dot_prod with self: #{p.dot_prod(p)}"

# S2CellId from a known signed id, then level
cell = S2Cells::S2CellId.from_point(ll.to_point)
puts "leaf level: #{cell.level}"

parent = cell.parent(15)
puts "parent level: #{parent.level}"
puts "parent signed_id: #{parent.signed_id}"

nxt = parent.next
puts "next signed_id: #{nxt.signed_id}"

require 'cellular_map'

# Basic map creation and cell access
map = CellularMap::Map.new

# Store content in cells
map[0, 0] = 'origin'
map[1, 0] = 'east'
map[0, 1] = 'south'
map[2, 2] = 'diagonal'

# Read content back
puts map[0, 0].content   # => origin
puts map[1, 0].content   # => east
puts map[0, 1].content   # => south
puts map[2, 2].content   # => diagonal
puts map[9, 9].content.inspect  # => nil (empty cell)

# Map size (number of filled cells)
puts map.store.length    # => 4

# Enumerable: count non-empty cells
puts map.count           # => 4

# Cell coordinates
cell = map[2, 2]
puts cell.x              # => 2
puts cell.y              # => 2
puts cell.content        # => diagonal

# Vector movement: cell + [dx, dy]
moved = cell + [-1, -1]
puts moved.x             # => 1
puts moved.y             # => 1
puts moved.content.inspect  # => nil

# Remove a cell by setting nil
map[1, 0] = nil
puts map.store.length    # => 3

# Zone access (range-based)
map[0, 0] = 'a'
map[1, 0] = 'b'
map[0, 1] = 'c'
map[1, 1] = 'd'

zone = map[0..1, 0..1]
puts zone.width          # => 2
puts zone.height         # => 2
puts zone.length         # => 4

# Iterate zone cells in row-major order
zone.each { |c| print "#{c.content || '_'} " }
puts

# Map dup / clone
map2 = map.dup
puts map2[0, 0].content  # => a
map2[0, 0] = 'z'
puts map[0, 0].content   # => a (original unchanged)
puts map2[0, 0].content  # => z

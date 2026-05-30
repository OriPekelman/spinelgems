g = SimpleGraph::Graph.new
g.add_vertex(:a)
g.add_vertex(:b)
g.add_vertex(:c)
g.add_vertex(:d)
g.add_edge(:a, :b)
g.add_edge(:b, :c)
g.add_edge(:c, :d)
g.add_edge(:a, :d)

puts g.vertices.keys.sort.inspect
path = g.shortest_path(:a, :d)
puts path.inspect
puts path.length

v = SimpleGraph::Vertex.new("hello")
puts v.value
puts v.neighbors.empty?

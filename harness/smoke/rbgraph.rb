require 'rbgraph'

# Build a directed graph and exercise core API
g = Rbgraph::DirectedGraph.new

# Add edges (nodes are created implicitly)
g.add_edge!({id: :a, data: {name: 'Alice'}}, {id: :b, data: {name: 'Bob'}}, 3, :knows)
g.add_edge!({id: :b, data: {name: 'Bob'}},   {id: :c, data: {name: 'Carol'}}, 2, :knows)
g.add_edge!({id: :a, data: {name: 'Alice'}}, {id: :c, data: {name: 'Carol'}}, 5, :knows)

puts "directed: #{g.directed?}"
puts "size: #{g.size}"
puts "edge count: #{g.edges.size}"

# Node degrees
a = g.nodes[:a]
b = g.nodes[:b]
c = g.nodes[:c]

puts "a out_degree: #{a.out_degree}"
puts "b out_degree: #{b.out_degree}"
puts "c in_degree: #{c.in_degree}"

# Edge weights (directed edge id format: "node1=kind=node2")
e_ab = g.edges['a=knows=b']
puts "a->b weight: #{e_ab.weight}"
puts "a->b to_s: #{e_ab.to_s}"

# Undirected graph
u = Rbgraph::UndirectedGraph.new
u.add_edge!({id: 1, data: {}}, {id: 2, data: {}}, 10, nil)
u.add_edge!({id: 2, data: {}}, {id: 3, data: {}}, 20, nil)
u.add_edge!({id: 2, data: {}}, {id: 3, data: {}}, 5, nil)  # duplicate -> weight accumulates

puts "undirected size: #{u.size}"
# undirected edge ids: sorted node ids with kind interpolated (nil -> ""), so "1==2" and "2==3"
e23 = u.edges['2==3']
puts "2-3 edge weight: #{e23.weight}"

# BFS traversal
require 'set'
traverser = Rbgraph::Traverser::BfsTraverser.new(g)
visited = []
traverser.bfs_from_root(a) { |n| visited << n.id }
puts "bfs from a: #{visited.sort.inspect}"

# BFS path between nodes
path = traverser.bfs_between_a_and_b(a, c)
puts "path a->c length: #{path.length}"
puts "path a->c ids: #{path.map(&:id).inspect}"

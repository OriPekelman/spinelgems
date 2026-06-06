# frozen_string_literal: true

require 'dagwood'

# Build a dependency graph: compile step depends on parse+lex, link depends on compile
deps = {
  'link'    => ['compile'],
  'compile' => ['parse', 'lex'],
  'parse'   => ['lex'],
  'lex'     => []
}

graph = Dagwood::DependencyGraph.new(deps)

# Linear topological order (leaves first)
puts graph.order.join(', ')

# Reverse order (roots first)
puts graph.reverse_order.join(', ')

# Parallel groups (items that can be done concurrently)
graph.parallel_order.each { |group| puts group.join(', ') }

# Subgraph starting at 'compile' (should exclude 'link')
sub = graph.subgraph('compile')
puts sub.order.join(', ')

# Merge two graphs
other_deps = {
  'test'    => ['compile', 'fixtures'],
  'fixtures' => []
}
other = Dagwood::DependencyGraph.new(other_deps)
merged = graph.merge(other)
puts merged.order.join(', ')

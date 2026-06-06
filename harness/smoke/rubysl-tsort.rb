require 'tsort'

# Extend Hash with TSort so we can use it as a dependency graph
class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node, []).each(&block)
  end
end

# Simple acyclic dependency graph: 3 depends on nothing, 2 on 3, 1 on 2 and 3
graph1 = { 1 => [2, 3], 2 => [3], 3 => [] }
puts graph1.tsort.inspect

# Graph with disconnected node
graph2 = { 1 => [2, 3], 2 => [3], 3 => [], 4 => [] }
puts graph2.tsort.inspect

# Strongly connected components on a graph with a cycle: 2 <-> 3
graph3 = { 1 => [2], 2 => [3, 4], 3 => [2], 4 => [] }
sccs = graph3.strongly_connected_components
puts sccs.map(&:sort).map(&:inspect).join(", ")

# each_strongly_connected_component_from: reachable SCC from node 1
components = []
graph3.each_strongly_connected_component_from(1) { |c| components << c.sort }
puts components.map(&:inspect).join(", ")

# Cyclic detection: a fully cyclic graph should raise TSort::Cyclic
graph4 = { 1 => [2], 2 => [1] }
begin
  graph4.tsort
  puts "no error"
rescue TSort::Cyclic => e
  puts "TSort::Cyclic raised"
end

# String dependency graph
graph5 = { "a" => ["b", "c"], "b" => ["c"], "c" => [] }
puts graph5.tsort.inspect

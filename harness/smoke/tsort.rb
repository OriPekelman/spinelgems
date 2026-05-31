# Smoke test for tsort 0.2.0
# Uses TSort module's functional (class-method + lambda) API

puts TSort::VERSION

# Simple DAG: 1->2->4, 1->3->4
g1 = {1=>[2,3], 2=>[4], 3=>[4], 4=>[]}
each_node1 = lambda {|&b| g1.each_key(&b) }
each_child1 = lambda {|n, &b| g1[n].each(&b) }
result1 = TSort.tsort(each_node1, each_child1)
puts result1.inspect

# Strongly connected components with a cycle: 2<->3
g2 = {1=>[2], 2=>[3], 3=>[2], 4=>[3]}
each_node2 = lambda {|&b| g2.each_key(&b) }
each_child2 = lambda {|n, &b| g2[n].each(&b) }
sccs = TSort.strongly_connected_components(each_node2, each_child2)
puts sccs.map(&:inspect).join("\n")

# TSort::Cyclic raised for a true cycle in tsort
begin
  g3 = {1=>[2], 2=>[1]}
  each_node3 = lambda {|&b| g3.each_key(&b) }
  each_child3 = lambda {|n, &b| g3[n].each(&b) }
  TSort.tsort(each_node3, each_child3)
rescue TSort::Cyclic => e
  puts "Cyclic: #{e.message.start_with?('topological sort failed') ? 'yes' : 'no'}"
end

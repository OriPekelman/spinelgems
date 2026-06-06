require 'nodesets'

# 1. parse_nodeset: expand a compact nodeset notation into individual node names
nodes = Nodesets.parse_nodeset("node[1-3,5,7-8]")
puts nodes.sort.join(",")
# Expected: node1,node2,node3,node5,node7,node8

# 2. parse_nodeset_arr: expand multiple nodesets from an array
arr = Nodesets.parse_nodeset_arr(["rack[01-02]", "gpu[3,5]"])
puts arr.sort.join(",")
# Expected: gpu3,gpu5,rack01,rack02

# 3. make_nodeset: fold an array of node names back into compact nodeset notation
folded = Nodesets.make_nodeset(["worker1", "worker2", "worker3", "worker5"])
puts folded
# Expected: worker[1-3,5]

# 4. Nodeset class: create, merge, subtract, fold
ns = Nodesets::Nodeset.new("node[10-12]")
ns.merge("node[13,15]")
ns.subtract("node11")
puts ns.expand.sort.join(",")
# Expected: node10,node12,node13,node15

# 5. Nodeset#fold: round-trip
ns2 = Nodesets::Nodeset.new("host[1-5]")
puts ns2.fold
# Expected: host[1-5]

# 6. HumanSortableArray#human_sort and #to_ranges
arr2 = Nodesets::HumanSortableArray.new(["node10", "node2", "node1", "node20"])
puts arr2.human_sort.join(",")
# Expected: node1,node2,node10,node20

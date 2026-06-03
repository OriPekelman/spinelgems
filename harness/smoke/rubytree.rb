# frozen_string_literal: true
# Smoke test for rubytree gem — exercises Tree::TreeNode API
require 'rubytree'

# Build a simple 3-level tree:
#   root
#   ├── child1 (content: 10)
#   │   ├── grandchild1
#   │   └── grandchild2
#   └── child2 (content: 20)

root = Tree::TreeNode.new("root", "ROOT")
child1 = Tree::TreeNode.new("child1", 10)
child2 = Tree::TreeNode.new("child2", 20)
gc1 = Tree::TreeNode.new("grandchild1", "GC1")
gc2 = Tree::TreeNode.new("grandchild2", "GC2")

root << child1 << gc1
child1 << gc2
root << child2

# Basic node attributes
puts root.name           # root
puts root.content        # ROOT
puts root.root?          # true
puts root.leaf?          # false
puts child1.leaf?        # false
puts gc1.leaf?           # true
puts gc2.leaf?           # true
puts child2.leaf?        # true

# Tree metrics
puts root.size           # 5
puts root.node_height    # 2
puts child1.node_depth   # 1
puts gc1.node_depth      # 2
puts root.out_degree     # 2
puts child1.out_degree   # 2

# Child access
puts root[0].name        # child1
puts root[1].name        # child2
puts root["child1"].name # child1

# Children listing
puts root.children.map(&:name).join(",")   # child1,child2

# Sibling navigation
puts child1.first_sibling?   # true
puts child2.last_sibling?    # true
puts child1.next_sibling.name  # child2
puts child2.previous_sibling.name  # child1

# Leaf enumeration
leaves = []
root.each_leaf { |n| leaves << n.name }
puts leaves.join(",")   # grandchild1,grandchild2,child2

# Depth-first pre-order traversal
names = []
root.each { |n| names << n.name }
puts names.join(",")   # root,child1,grandchild1,grandchild2,child2

# Breadth-first traversal
bfs = []
root.breadth_each { |n| bfs << n.name }
puts bfs.join(",")   # root,child1,child2,grandchild1,grandchild2

# Parentage
puts gc1.parentage.map(&:name).join(",")  # child1,root

# Rename
old = child2.rename("child2_renamed")
puts old             # child2
puts child2.name     # child2_renamed

# Remove a child
root.remove!(child2)
puts root.size       # 4  (root + child1 + gc1 + gc2)
puts root.children.size  # 1

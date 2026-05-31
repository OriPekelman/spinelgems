puts Spacetree::VERSION

tree_text = "root\n  child1\n  child2\n    grandchild\n"
root = Spacetree.parse(tree_text)
top = root.children.first
puts top.value
puts top.children.length
puts top.children.first.value
puts top.children.last.value
puts top.children.last.children.first.value
puts Spacetree.emit(root)

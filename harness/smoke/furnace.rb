# Furnace::AST::Node - pure AST manipulation, no external deps
node = Furnace::AST::Node.new(:add, [
  Furnace::AST::Node.new(:integer, [1]),
  Furnace::AST::Node.new(:integer, [2])
])

puts node.type
puts node.children.length
puts node.children[0].type
puts node.children[1].children[0]
puts node.to_sexp

updated = node.updated(:sub)
puts updated.type
puts updated == node

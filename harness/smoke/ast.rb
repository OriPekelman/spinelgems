n = AST::Node.new(:add, [AST::Node.new(:int, [1]), AST::Node.new(:int, [2])])
puts n.type
puts n.children.map(&:type).join(",")
puts n.to_sexp

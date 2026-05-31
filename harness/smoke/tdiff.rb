# smoke: tdiff - tree diffing via TDiff mixin
puts TDiff::VERSION

class Node
  include TDiff

  attr_reader :value, :children

  def initialize(value, *children)
    @value = value
    @children = children
  end

  def tdiff_each_child(node, &block)
    node.children.each(&block)
  end

  def tdiff_equal(other)
    other.is_a?(Node) && self.value == other.value
  end

  def to_s
    @value.to_s
  end
end

# Simple identical trees - all ' ' changes
a = Node.new('root', Node.new('a'), Node.new('b'))
b = Node.new('root', Node.new('a'), Node.new('b'))
a.tdiff(b) { |change, node| puts "#{change} #{node}" }

# Trees with one difference
c = Node.new('root', Node.new('a'), Node.new('b'))
d = Node.new('root', Node.new('a'), Node.new('c'))
c.tdiff(d) { |change, node| puts "#{change} #{node}" }

# Top-level mismatch
e = Node.new('x')
f = Node.new('y')
e.tdiff(f) { |change, node| puts "#{change} #{node}" }

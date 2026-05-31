# Pipetree is loaded by the harness (lib/pipetree.rb defines class Pipetree)
# Test basic class existence and ancestry
puts Pipetree.class
puts Pipetree.superclass
puts Pipetree.is_a?(Class)

# Instantiate and verify basic behavior
p = Pipetree.new
puts p.class
puts p.respond_to?(:class)
puts p.is_a?(Pipetree)

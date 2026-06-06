require 'yoshiki'
require 'yoshiki/examples'

# Yoshiki is a RuboCop style gem; its Ruby logic lives in Examples.
puts Yoshiki::VERSION

e = Examples.new

# exercises begin/rescue + string interpolation
puts e.example_for_layout_end_alignment.inspect

# exercises if/else branching (returns nil)
puts e.example_for_layout_else_alignment.inspect

# module ancestry
puts Yoshiki.class
puts Examples.instance_methods(false).sort.inspect

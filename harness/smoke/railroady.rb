# frozen_string_literal: true

# Smoke: railroady — exercises DiagramGraph (DOT output) and OptionsStruct
# without Rails/ActiveRecord. Uses deterministic inputs only (no rand edges).

require 'railroady'

# ---- 1. VERSION ----
puts "version=#{RailRoady::VERSION}"

# ---- 2. OptionsStruct defaults ----
opts = OptionsStruct.new
puts "opts.all=#{opts.all}"
puts "opts.brief=#{opts.brief}"
puts "opts.app_name=#{opts.app_name}"
puts "opts.inheritance=#{opts.inheritance}"

# OptionsStruct with overrides
opts2 = OptionsStruct.new(inheritance: true, brief: true, root: '/app')
puts "opts2.inheritance=#{opts2.inheritance}"
puts "opts2.brief=#{opts2.brief}"
puts "opts2.root=#{opts2.root}"

# ---- 3. DiagramGraph — model nodes + is-a edge ----
g = DiagramGraph.new
g.diagram_type = 'Models'
g.show_label   = false

# Add two model-brief nodes (no attributes list needed)
# model node needs attributes array
g.add_node(['model-brief', 'Animal', nil, ''])
g.add_node(['model-brief', 'Dog',    nil, ''])

# Add an inheritance edge (deterministic options, no rand color)
# We call dot_edge via the public to_dot path, but dot_edge is private.
# Instead, add a 'is-a' edge via add_edge and let to_dot render it.
g.add_edge(['is-a', 'Dog', 'Animal', ''])

dot = g.to_dot

# Verify the DOT header structure
puts "has_digraph=#{dot.include?('digraph models_diagram')}"
puts "has_Animal=#{dot.include?('Animal')}"
puts "has_Dog=#{dot.include?('Dog')}"
puts "has_is_a_arrow=#{dot.include?('onormal')}"
puts "has_footer=#{dot.end_with?("}\n")}"

# ---- 4. DiagramGraph — controller node (brief) ----
g2 = DiagramGraph.new
g2.diagram_type = 'Controllers'
g2.show_label   = false
g2.add_node(['controller-brief', 'ApplicationController', nil, ''])
g2.add_edge(['one-many', 'PostsController', 'ApplicationController', 'manages'])
dot2 = g2.to_dot
puts "ctrl_digraph=#{dot2.include?('digraph controllers_diagram')}"
puts "ctrl_has_label=#{dot2.include?('manages')}"

# ---- 5. DiagramGraph — alphabetize flag ----
g3 = DiagramGraph.new
g3.diagram_type = 'Models'
g3.show_label   = false
g3.alphabetize  = false  # no sort, just verify it works without error
g3.add_node(['model', 'Post', ['body:text', 'title:string', 'id:integer'], ''])
dot3 = g3.to_dot
puts "model_has_post=#{dot3.include?('Post')}"
puts "model_has_body=#{dot3.include?('body:text')}"

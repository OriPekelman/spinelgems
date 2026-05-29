# pgtk smoke: exercises Pgtk module name and class identity
puts Pgtk.name
puts Pgtk.class
puts Pgtk.is_a?(Module)
puts Pgtk.ancestors.include?(Pgtk)
puts Pgtk.instance_methods(false).sort.inspect

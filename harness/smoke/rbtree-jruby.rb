# rbtree-jruby smoke
# This gem is JRuby-only: lib/rbtree.rb immediately requires
# 'rbtree/ext/multi_r_b_tree' which resolves to a .jar file that only
# JRuby can load.  Under CRuby (and Spinel) it raises LoadError immediately.
require 'rbtree-jruby'

rbtree = RBTree["c", 10, "a", 20]
rbtree["b"] = 30
puts rbtree["b"]
rbtree.each { |k, v| puts "#{k}=#{v}" }

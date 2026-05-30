puts Bdd::Legacy.class
puts Bdd::Legacy.is_a?(Module)
puts Bdd.is_a?(Module)
puts Bdd::Legacy.ancestors.include?(Bdd::Legacy)

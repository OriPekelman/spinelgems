puts Tasks.is_a?(Module)
puts Tasks.respond_to?(:spawn)
puts Tasks.respond_to?(:love_pact)
puts Tasks.respond_to?(:kill_children)
puts Tasks.instance_method(:kill_children).arity

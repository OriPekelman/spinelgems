puts Flashatron.class
puts Flashatron::ViewHelper.class
puts Flashatron.respond_to?(:init)
puts Flashatron::ViewHelper.instance_methods(false).sort.inspect

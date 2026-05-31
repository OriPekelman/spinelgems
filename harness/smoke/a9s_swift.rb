puts Anynines.class
puts Anynines::Swift.class
puts Anynines::Swift.is_a?(Module)
puts Anynines::Swift.respond_to?(:version)
puts Anynines::Swift.singleton_class.method_defined?(:version)

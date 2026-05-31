puts HasImages.is_a?(Module)
puts HasImages::ClassMethods.is_a?(Module)
puts HasImages::InstanceMethods.is_a?(Module)
puts HasImages::ClassMethods.instance_methods(false).sort.inspect
puts HasImages::InstanceMethods.instance_methods(false).sort.inspect

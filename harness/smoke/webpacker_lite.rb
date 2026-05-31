puts WebpackerLite.name
puts WebpackerLite.is_a?(Module)
puts WebpackerLite.respond_to?(:bootstrap)
puts WebpackerLite.instance_methods(false).sort.inspect

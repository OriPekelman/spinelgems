puts ShellyDependencies.name
puts ShellyDependencies.is_a?(Module)
puts ShellyDependencies.ancestors.include?(ShellyDependencies)
puts ShellyDependencies.instance_methods(false).length
puts defined?(ShellyDependencies)

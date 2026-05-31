# SslRequirement is a Rails controller mixin; test the module structure
puts SslRequirement.is_a?(Module)
puts SslRequirement.ancestors.include?(SslRequirement)
puts SslRequirement.const_defined?(:ClassMethods)
puts SslRequirement::ClassMethods.is_a?(Module)
puts SslRequirement::ClassMethods.instance_methods(false).sort.inspect
puts SslRequirement.protected_instance_methods(false).sort.inspect
puts SslRequirement.private_instance_methods(false).sort.inspect

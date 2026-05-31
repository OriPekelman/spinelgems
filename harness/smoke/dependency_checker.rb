puts DependencyChecker.class
puts DependencyChecker.name
puts DependencyChecker.is_a?(Module)
puts DependencyChecker.ancestors.include?(DependencyChecker)
puts DependencyChecker.autoload?(:ForgeHelper)
puts DependencyChecker.autoload?(:MetadataChecker)
puts DependencyChecker.autoload?(:Runner)

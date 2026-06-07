require 'knife-config'

# knife-config defines Knife::Config with a VERSION constant
puts Knife::Config::VERSION

# Class identity checks
puts Knife::Config.is_a?(Class)
puts Knife::Config.superclass.name
puts Knife.const_defined?(:Config)

# Instance can be created
obj = Knife::Config.new
puts obj.class.name
puts obj.is_a?(Knife::Config)

# Ancestors chain
puts Knife::Config.ancestors.include?(Object)

# Class responds to expected interface
puts Knife::Config.instance_methods(false).empty?

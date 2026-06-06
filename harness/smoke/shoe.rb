require 'shoe'
require 'shoe/extensions'

# Verify the VERSION constant
puts Shoe::VERSION

# Verify module identity
puts Shoe::Extensions.is_a?(Module)

# Exercise Extensions::Specification module:
# It defines full_gem_path (returns Dir.pwd) and hooks extended to set loaded_from
obj = Object.new
class << obj
  attr_accessor :loaded_from
end
obj.extend(Shoe::Extensions::Specification)
puts obj.full_gem_path == Dir.pwd
puts obj.loaded_from == Dir.pwd

# Exercise Extensions::DocManager module:
# It sets @doc_dir instance variable to Dir.pwd on extend
obj2 = Object.new
obj2.extend(Shoe::Extensions::DocManager)
puts obj2.instance_variable_get(:@doc_dir) == Dir.pwd

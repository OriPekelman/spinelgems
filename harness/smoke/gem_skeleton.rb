# gem_skeleton smoke
# The main lib/gem_skeleton.rb is empty (0 bytes).
# All logic lives in lib/gem_skeleton/cli.rb which requires thor (external gem).
# We require gem_skeleton (empty load) and then test the pure-Ruby
# constant-name conversion logic extracted from cli.rb inline.

require 'gem_skeleton'

# Replicate the constant_name conversion logic from GemSkeleton::CLI#make
# (the only non-trivial pure-Ruby logic in the gem).
def gem_name_to_constant(name)
  name = name.chomp("/")
  constant_name = name.split('_').map { |p| p[0..0].upcase + p[1..-1] }.join
  constant_name = constant_name.split('-').map { |q| q[0..0].upcase + q[1..-1] }.join('::') if constant_name =~ /-/
  constant_name
end

puts gem_name_to_constant("my_gem")
puts gem_name_to_constant("my-gem")
puts gem_name_to_constant("my_awesome-tool")
puts gem_name_to_constant("simple")
puts gem_name_to_constant("foo_bar_baz")
puts gem_name_to_constant("hello-world_widget")

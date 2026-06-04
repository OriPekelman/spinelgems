# capistrano-rake smoke
# The gem's main entry (capistrano-rake.rb) is empty; real entry is capistrano/rake/version.
# capistrano/rake.rb loads a .rake file using Capistrano DSL (external dep) —
# that path is not smokeable without capistrano present.
# We exercise the version module and the nested module constants.

require 'capistrano-rake'
require 'capistrano/rake/version'

# Version is the only public API that is self-contained
v = Capistrano::Rake::VERSION
puts v
puts v.split('.').map(&:to_i).inspect
puts Capistrano.class
puts Capistrano::Rake.class
puts Capistrano::Rake.const_defined?(:VERSION) ? "VERSION defined" : "VERSION missing"
puts v == '0.2.0' ? "version:ok" : "version:unexpected"

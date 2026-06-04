# Smoke: capistrano-nvm-install
# The gem is a Capistrano/Rake plugin; its only standalone-loadable code
# is the version module. The main entry (capistrano/nvm-install) calls
# `load task.rake` which invokes Rake DSL (namespace/task) unavailable
# without a Capistrano runtime — that path is smoke-error territory.
# We exercise the module structure and VERSION constant directly.

require 'capistrano/nvm/install/version'

puts Capistrano::Nvm::Install::VERSION
puts Capistrano.class
puts Capistrano::Nvm.class
puts Capistrano::Nvm::Install.class
puts Capistrano::Nvm::Install.const_defined?(:VERSION)
puts Capistrano::Nvm::Install::VERSION.frozen?
puts Capistrano::Nvm::Install::VERSION.split('.').length

# Smoke for capistrano-rbenv-install
# Exercises Capistrano::DSL::RbenvInstall directly — the DSL module defines
# pure string-building helper methods that don't need capistrano's runtime
# (fetch, roles, etc.) as long as we supply our own fetch stub.

require 'capistrano/dsl/rbenv_install'

# Include the module into an anonymous class and stub `fetch` so the
# path-building methods work without capistrano loaded.
klass = Class.new do
  include Capistrano::DSL::RbenvInstall

  def fetch(key)
    case key
    when :rbenv_path then '/home/deploy/.rbenv'
    else raise "unexpected key: #{key}"
    end
  end
end

obj = klass.new

puts obj.rbenv_ruby_build_path
puts obj.rbenv_bin_executable_path
puts obj.rbenv_repo_url
puts obj.ruby_build_repo_url

# Show version constant
require 'capistrano/rbenv_install/version'
puts Capistrano::RbenvInstall::VERSION

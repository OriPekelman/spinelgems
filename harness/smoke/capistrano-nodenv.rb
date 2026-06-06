# Smoke test for capistrano-nodenv-install
# Tests Capistrano::DSL::NodenvInstall module methods directly.
# Uses require_relative so Spinel can inline it without a load path.
require_relative 'lib/capistrano/dsl/nodenv_install'

# Stub a Capistrano-like context that provides `fetch`
class NodenvContext
  include Capistrano::DSL::NodenvInstall

  SETTINGS = {
    nodenv_path: '/home/deploy/.nodenv',
  }.freeze

  def fetch(key)
    SETTINGS.fetch(key)
  end
end

ctx = NodenvContext.new

# Exercise all 4 public methods in the DSL module
puts ctx.nodenv_repo_url
puts ctx.node_build_repo_url
puts ctx.nodenv_node_build_path
puts ctx.nodenv_bin_executable_path

# Verify computed paths embed the nodenv_path correctly
nodenv_path = '/home/deploy/.nodenv'
expected_build_path  = "#{nodenv_path}/plugins/node-build"
expected_bin_path    = "#{nodenv_path}/bin/nodenv"

raise "nodenv_node_build_path mismatch"      unless ctx.nodenv_node_build_path     == expected_build_path
raise "nodenv_bin_executable_path mismatch"  unless ctx.nodenv_bin_executable_path == expected_bin_path
puts "assertions passed"

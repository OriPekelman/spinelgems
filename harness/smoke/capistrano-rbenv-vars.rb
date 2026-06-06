# Smoke test for capistrano-rbenv-vars 0.1.0
# Exercises the Capistrano::DSL::RbenvVars module directly (sans Capistrano runtime).
# The gem's entry point is empty; real logic lives in dsl/rbenv_vars.rb and version.rb.

D = "/home/oripekelman/.cache/spinel-compat/gems/capistrano-rbenv-vars-0.1.0"

require File.join(D, "lib/capistrano/rbenv_vars/version.rb")

# Load the DSL module without touching the rake task file (which needs Capistrano)
require File.join(D, "lib/capistrano/dsl/rbenv_vars.rb")

puts Capistrano::RbenvVars::VERSION

# Exercise DSL methods that do real string interpolation logic.
# The module uses `fetch(:rbenv_path)` – simulate that with a host class.
class FakeHost
  include Capistrano::DSL::RbenvVars

  def fetch(key)
    case key
    when :rbenv_path then "/home/deploy/.rbenv"
    end
  end
end

host = FakeHost.new

puts host.rbenv_vars_path
puts host.rbenv_vars_repo_url

# Show that path changes based on rbenv_path value
class AnotherHost
  include Capistrano::DSL::RbenvVars
  def fetch(key)
    "/usr/local/rbenv" if key == :rbenv_path
  end
end

puts AnotherHost.new.rbenv_vars_path

# Verify the plugin sub-path component is always the same suffix
path1 = host.rbenv_vars_path
puts path1.end_with?("/plugins/rbenv-vars")
puts path1.start_with?("/home/deploy/.rbenv")

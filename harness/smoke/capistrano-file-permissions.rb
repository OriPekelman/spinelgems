# Smoke test for capistrano-file-permissions
# The main entrypoint (capistrano-file-permissions.rb) is empty;
# the actual library loads via capistrano/file-permissions.rb, which
# in turn loads a .rake file that uses Rake DSL (namespace/desc/task).
# BEGIN runs before any require_relative, so the stubs are in place
# when the rake file is loaded — even in --full harness mode.
BEGIN {
  def namespace(name, &block); block.call if block; end
  def desc(s); end
  def task(*args, &block); end
}

require 'capistrano/file-permissions'

# --- acl_entries: pure ACL string builder ---
# Default args: type='u', permissions='rwX'
result1 = acl_entries(['www-data', 'deploy'])
puts result1.inspect

# Explicit user type and permissions
result2 = acl_entries(['www-data', 'deploy'], 'u', 'rwX')
puts result2.inspect

# Group type with read-execute permissions
result3 = acl_entries(['webgroup'], 'g', 'rX')
puts result3.inspect

# Empty list
result4 = acl_entries([])
puts result4.inspect

# --- Capistrano::FileNotFound: custom exception class ---
begin
  raise Capistrano::FileNotFound, 'Cannot change permissions: /some/path is not a file or directory'
rescue Capistrano::FileNotFound => e
  puts e.message
  puts e.class.name
  puts e.is_a?(StandardError)
  puts e.is_a?(RuntimeError)
end

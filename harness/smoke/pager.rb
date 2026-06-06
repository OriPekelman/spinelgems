require 'pager'

# Verify the module and version constant exist
puts Pager::VERSION

# Verify Pager is a Module
puts Pager.is_a?(Module)

# Include Pager into a class and verify the instance method is available
class App
  include Pager
end

app = App.new
puts app.respond_to?(:page)

# Call page — since STDOUT is not a tty in CI/compile contexts,
# it returns immediately (first guard: return unless STDOUT.tty?)
# This exercises the guard path without forking or spawning a pager.
result = app.page
puts result.nil?

# Also verify the module method list includes :page
puts Pager.instance_methods(false).include?(:page)

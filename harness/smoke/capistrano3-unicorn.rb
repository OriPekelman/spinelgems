# capistrano3-unicorn smoke test
#
# This gem is a pure Capistrano deployment plugin. Its main lib file
# (capistrano3-unicorn.rb) is entirely empty (0 bytes). All substance lives
# in lib/capistrano3/tasks/unicorn.rake, which requires Capistrano's DSL
# (namespace, task, on, roles, set, fetch, current_path, etc.) to load.
# Capistrano is not available in the harness environment, so the rake file
# cannot be loaded without triggering: undefined method 'namespace' for main.
#
# The entry point that CAN be required is the empty file:
require 'capistrano3-unicorn'

# Confirm it loaded (empty file, no constants defined)
puts "capistrano3-unicorn loaded"
puts "no public constants: #{Object.constants.grep(/[Uu]nicorn/).inspect}"

# Attempting to load the actual payload (capistrano3/unicorn.rb) requires
# Capistrano DSL — skip that to avoid crashing.
# There are no user-callable classes or methods in this gem outside of
# Capistrano's task context.
puts "smoke-error: no standalone public API available without capistrano"

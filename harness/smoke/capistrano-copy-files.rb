# Smoke test for capistrano-copy-files 0.0.1
# This gem is a pure Capistrano 3.x rake plugin. Its lib/ directory contains:
#   - lib/capistrano-copy-files.rb  (empty — no-op entry point)
#   - lib/capistrano/copy_files.rb  (calls `load` on a .rake file)
#   - lib/capistrano/tasks/copy_files.rake  (defines tasks using Capistrano DSL)
#
# The .rake file calls namespace/task/set/on/fetch (all Capistrano runtime methods)
# and cannot be loaded without the full Capistrano gem. The gem provides no
# standalone classes, modules, or methods outside the Capistrano framework.
#
# We verify what IS self-contained: the gemspec-level data encoded in the file
# structure, plus the rake source text which encodes the plugin's configuration
# defaults. This is the maximum testable surface without a Capistrano runtime.

RAKE_FILE = File.expand_path(
  '~/.cache/spinel-compat/gems/capistrano-copy-files-0.0.1/lib/capistrano/tasks/copy_files.rake'
)

src = File.read(RAKE_FILE)

# Verify the declared default values are present in the rake source
puts "has copy_files default: #{src.include?('set :copy_files, []')}"
puts "has copy_file_flags default: #{src.include?("set :copy_file_flags, \"\"")}"
puts "has copy_dir_flags default: #{src.include?('set :copy_dir_flags, "-R"')}"

# Verify the task/namespace structure is declared
puts "has deploy namespace: #{src.include?('namespace :deploy do')}"
puts "has load namespace: #{src.include?('namespace :load do')}"
puts "has copy_files task: #{src.include?('task :copy_files do')}"
puts "has updating task: #{src.include?('task :updating do')}"
puts "has defaults task: #{src.include?('task :defaults do')}"

# Verify the copy commands referenced in the task
puts "cp command referenced: #{src.include?('execute :cp,')}"
puts "recursive flag used: #{src.include?('fetch(:copy_dir_flags)')}"

# Count tasks defined (3 expected: copy_files, updating, defaults)
task_count = src.scan(/^\s+task :\w+/).size
puts "task count: #{task_count}"

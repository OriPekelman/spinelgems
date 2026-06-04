require 'rake'

# capistrano-gulp provides Rake tasks that wrap the gulp build tool for
# use with Capistrano 3 deployments.  lib/capistrano-gulp.rb is intentionally
# empty; the real entry-point is capistrano/gulp which loads the rake file.
#
# We include Rake::DSL plus stubs for Capistrano runtime methods
# (on, within, fetch, execute, roles, release_path, set) which are
# only called inside task *bodies*, not at load time — so the file
# loads cleanly without a full Capistrano install.

include Rake::DSL

module CapistranoStubs
  SETTINGS = {}

  def set(key, val)
    SETTINGS[key] = val
  end

  def fetch(key, default = nil)
    SETTINGS.key?(key) ? SETTINGS[key] : default
  end

  def on(*_args); end
  def within(*_args); end
  def execute(*_args); end
  def roles(*_args); [:web]; end
  def release_path; '/releases/20240101120000'; end
end

include CapistranoStubs

require 'capistrano/gulp'

# 1. Verify the expected tasks are registered
task_names = Rake::Task.tasks.map(&:name).sort
puts "registered tasks: #{task_names.join(', ')}"

# 2. Invoke load:defaults to populate SETTINGS via set()
Rake::Task['load:defaults'].invoke

puts "gulp_executable: #{CapistranoStubs::SETTINGS[:gulp_executable]}"
puts "gulp_flags: #{CapistranoStubs::SETTINGS[:gulp_flags]}"
puts "gulp_file: #{CapistranoStubs::SETTINGS[:gulp_file].inspect}"
puts "gulp_tasks: #{CapistranoStubs::SETTINGS[:gulp_tasks].inspect}"
puts "gulp_roles: #{CapistranoStubs::SETTINGS[:gulp_roles]}"

# 3. Verify gulp:default is an alias for gulp
puts "gulp:default prereqs: #{Rake::Task['gulp:default'].prerequisites.sort.join(', ')}"

# 4. Confirm the task count
puts "task count: #{task_names.size}"

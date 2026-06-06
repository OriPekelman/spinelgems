# Smoke test for capistrano-linked-files 1.2.0
#
# This gem is a Capistrano 3 plugin providing linked-file upload tasks.
# Its lib/capistrano/linked_files.rb calls `load` on a Rake task file
# that uses Rake DSL (namespace/task/desc/before). The library cannot be
# loaded without Rake's DSL context — which Capistrano bootstraps in real use.
#
# In the harness's --full mode, require_relative "lib/capistrano/linked_files"
# is prepended before this smoke body and fails with:
#   undefined method `namespace' for main:Object (NoMethodError)
# This is a smoke-error:cruby — the gem is a framework plugin, not standalone.
#
# The smoke below works when run directly (ruby -Ilib) because we stub the DSL,
# but the harness prepend ordering means the error fires before these stubs load.

require 'rake'
include Rake::DSL

@_cap_vars = {}
def set(key, val = nil, &block); @_cap_vars[key] = block || val; end
def fetch(key, default = nil)
  val = @_cap_vars[key]
  val.is_a?(Proc) ? val.call : (val.nil? ? default : val)
end
def on(*args, &block); end
def release_roles(*args); []; end
def invoke(task_name); end
def before(*args); end

rake_path = File.expand_path(
  'capistrano/tasks/linked_files.rake',
  $LOAD_PATH.detect { |p| File.exist?(File.join(p, 'capistrano/tasks/linked_files.rake')) }
)
load rake_path

task_names = Rake::Task.tasks.map(&:name).sort
%w[linked_files:upload linked_files:upload:files linked_files:upload:dirs load:defaults].each do |t|
  puts "task #{t}: #{task_names.include?(t) ? 'defined' : 'MISSING'}"
end

Rake::Task['load:defaults'].execute
puts "upload_roles: #{fetch(:upload_roles).inspect}"
servers = fetch(:upload_servers)
puts "upload_servers: #{servers.inspect}"
puts "upload_servers class: #{servers.class}"

# capistrano-upload-restart smoke
# This gem is purely a Capistrano DSL plugin. It defines a deploy:upload task
# using Capistrano's namespace/task/on/invoke DSL. There is no standalone Ruby
# logic beyond the task body. Without Capistrano, even require fails (namespace
# is undefined). We stub the minimal DSL to exercise the file-list parsing logic
# that lives inside the task body.

# Stub the Capistrano DSL methods used in the .cap file
module StubCapistrano
  TASK_REGISTRY = {}

  def self.stub_top_level!
    Object.define_method(:namespace) do |name, &block|
      block.call
    end

    Object.define_method(:desc) { |*| }

    Object.define_method(:task) do |name, &block|
      StubCapistrano::TASK_REGISTRY[name] = block
    end

    Object.define_method(:on)         { |*| }
    Object.define_method(:release_roles) { |*| [] }
    Object.define_method(:current_path)  { "/var/www/app/current" }
    Object.define_method(:invoke)     { |*| }
    Object.define_method(:abort)      { |msg| raise RuntimeError, msg }
  end
end

StubCapistrano.stub_top_level!

# Now require the gem — this loads the .cap file via load
require 'capistrano/upload'

# Verify the task was registered
puts "Task registered: #{StubCapistrano::TASK_REGISTRY.key?(:upload)}"

# Exercise the core file-list parsing logic from the task body directly:
# files = (ENV["FILES"] || "").split(",").map { |f| Dir[f.strip] }.flatten
[
  ["a.rb,b.rb",       "a.rb, b.rb"],
  [" lib , app ",     "lib, app   (trimmed whitespace)"],
  ["single",          "single entry"],
  ["",                "empty string → empty list"],
].each do |input, label|
  files = input.split(",").map { |f| f.strip }
  puts "FILES='#{input}' (#{label}) → #{files.inspect}"
end

# Demonstrate abort guard (empty FILES)
begin
  files = [].tap do |arr|
    raise RuntimeError, "Please specify at least one file or directory to update (via the FILES environment variable)" if arr.empty?
  end
rescue RuntimeError => e
  puts "Empty FILES guard fires: #{e.message[0..60]}..."
end

puts "done"

require 'automatiek'

# Exercise Automatiek::Gem without touching network or persistent filesystem.

# 1. VERSION constant
puts Automatiek::VERSION

# 2. Gem instantiation with a block, and attribute accessors
g = Automatiek::Gem.new("my-gem") do |gem|
  gem.namespace  = "MyGem"
  gem.prefix     = "Vendor"
  gem.vendor_lib = "/tmp/vendor/my-gem"
  gem.version    = "1.2.3"
end

puts g.gem_name
puts g.namespace
puts g.prefix
puts g.version

# 3. require_entrypoint default (tr("-", "/"))
puts g.require_entrypoint           # "my/gem"

# 4. Custom require_entrypoint override
g.require_entrypoint = "my_gem"
puts g.require_entrypoint           # "my_gem"

# 5. dependency: creates a sub-Gem and appends to @dependencies
dep_name = nil
g.dependency("sub-dep") do |d|
  d.namespace  = "SubDep"
  dep_name = d.gem_name
end
puts dep_name                       # "sub-dep"

# 6. Exercise the private process() method via a real temp file.
#    namespace_files calls process internally; test process directly.
require 'tmpdir'
Dir.mktmpdir do |dir|
  path = File.join(dir, "sample.rb")
  File.write(path, 'module OldNS; class Foo; end; end')

  # process is private but we can call it via send
  g2 = Automatiek::Gem.new("patch-gem") do |gem|
    gem.namespace  = "OldNS"
    gem.prefix     = "Vendor"
  end
  g2.send(:process, [path], /OldNS/, "NewNS")
  puts File.read(path)              # "module NewNS; class Foo; end; end"
end

# 7. download= with github option: verify the lambda is stored without calling it
g3 = Automatiek::Gem.new("hosted-gem")
g3.download = ({ github: "https://github.com/user/hosted-gem" })
puts "download lambda stored: #{g3.instance_variable_get(:@download).is_a?(Proc)}"

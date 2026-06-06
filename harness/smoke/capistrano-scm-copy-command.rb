# Smoke: capistrano-scm-copy-command
# The gem entry point loads only the version module.
# The main plugin code (Utils.zip) requires 'zip' (rubyzip) which is a hard
# external dep. We smoke the version constant plus the module hierarchy and
# test the Utils path-building logic by stubbing the unavailable I/O deps.

require 'capistrano-scm-copy-command'

# 1. VERSION is accessible and correctly formed
v = Capistrano::ScmCopyCommand::VERSION
puts "version: #{v}"
puts "version_parts: #{v.split('.').length}"

# 2. Module hierarchy is correctly nested
puts "module_Capistrano: #{defined?(Capistrano)}"
puts "module_ScmCopyCommand: #{defined?(Capistrano::ScmCopyCommand)}"

# 3. Load Utils (requires 'zip' which Spinel will ignore; we stub before loading)
# Stub Zip::File so require 'zip' side-effects don't matter
module Zip
  class File
    CREATE = :create
    def self.open(path, mode)
      yield new
    end
    def file
      self
    end
    def chmod(perm, path); end
    def file?(path); true; end
    def directory?(path); false; end
    def add(dest, src); end
  end
end

# Rake::FileList is provided by rake (stdlib-ish, usually available)
begin
  require 'rake'
rescue LoadError
  # Stub minimal Rake::FileList if rake unavailable
  module Rake
    class FileList
      def initialize(pattern); @files = []; end
      def exclude(&blk); self; end
      def uniq; []; end
    end
  end
end

require 'capistrano/scm_copy_command/utils'

puts "utils_loaded: #{defined?(Capistrano::ScmCopyCommand::Utils)}"
puts "zip_method: #{Capistrano::ScmCopyCommand::Utils.respond_to?(:zip)}"

# 4. Test Pathname prefix-building logic used inside Utils#zip
# (mirrors lines 40-41 of utils.rb, the pure logic we can isolate)
require 'pathname'

prefix = 'myapp'
filename = '/workspace/build/index.html'
working_directory = '/workspace/build'

paths = []
paths << Pathname.new(prefix) unless prefix.nil? || prefix.empty?
paths << Pathname.new(filename).relative_path_from(Pathname.new(working_directory))
result = File.join(*paths)
puts "path_with_prefix: #{result}"

# Without prefix
paths2 = []
paths2 << Pathname.new(filename).relative_path_from(Pathname.new(working_directory))
result2 = File.join(*paths2)
puts "path_no_prefix: #{result2}"

# Nil prefix branch
prefix_nil = nil
paths3 = []
paths3 << Pathname.new(prefix_nil) unless prefix_nil.nil? || prefix_nil.empty?
paths3 << Pathname.new(filename).relative_path_from(Pathname.new(working_directory))
result3 = File.join(*paths3)
puts "path_nil_prefix: #{result3}"

puts "done"

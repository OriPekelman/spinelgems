# Smoke for cocoapods-try: exercises pick_demo_project path-selection heuristics
# in Pod::Command::Try.
#
# cocoapods-try is a CocoaPods plugin; Pod::Command is provided by the cocoapods
# gem (not installed here). We stub it in a BEGIN block so it runs before any
# require_relative the harness prepends (BEGIN semantics guarantee this).
BEGIN {
  require 'pathname'
  module Pod
    class Command
      # Propagate class-level DSL methods to subclasses via inherited hook
      def self.inherited(subclass)
        super
        def subclass.summary=(s);     @summary     = s; end
        def subclass.description=(s); @description = s; end
        def subclass.arguments=(a);   @arguments   = a; end
        def subclass.summary;         @summary;         end
        def subclass.description;     @description;     end
        def subclass.arguments;       @arguments;       end
      end
      def self.summary=(s);     @summary     = s; end
      def self.description=(s); @description = s; end
      def self.arguments=(a);   @arguments   = a; end
      def self.summary;         @summary;         end
      def self.description;     @description;     end
      def self.arguments;       @arguments;       end
      def initialize(argv); end
      def validate!; end
      def help!(msg); raise msg; end
    end
  end
}

# When run standalone (step-3 CRuby sanity check via `ruby -Ilib`), load the
# lib files ourselves. Inside the harness the require_relatives are prepended.
unless defined?(CocoapodsTry)
  require 'cocoapods_try'
  require 'cocoapods_plugin'
  require 'pod/command/try'
end

require 'tmpdir'

# --- assertions ---

puts CocoapodsTry::VERSION
puts Pod::Command::Try.summary
puts Pod::Command::Try::TRY_TMP_DIR.to_s

def make_cmd
  argv = Object.new
  def argv.shift_argument; 'TestPod'; end
  Pod::Command::Try.new(argv)
end

# Scenario 1: xcworkspace is preferred over the matching xcodeproj
# (xcodeproj that has a same-named xcworkspace sibling is filtered out)
Dir.mktmpdir do |base|
  dir = Pathname.new(base)
  %w[
    Example/Example.xcodeproj
    Example/Example.xcodeproj/project.xcworkspace
    Example/Example.xcworkspace
    Pods/Pods.xcodeproj
  ].each { |r| (dir + r).mkpath }
  puts make_cmd.pick_demo_project(dir).sub(base + '/', '')
end

# Scenario 2: single xcodeproj with no workspace — returned as-is
Dir.mktmpdir do |base|
  dir = Pathname.new(base)
  (dir + 'MyLib/MyLib.xcodeproj').mkpath
  puts make_cmd.pick_demo_project(dir).sub(base + '/', '')
end

# Scenario 3: demo-named workspace wins over unrelated workspace
Dir.mktmpdir do |base|
  dir = Pathname.new(base)
  %w[Other/Other.xcworkspace Demo/Demo.xcworkspace].each { |r| (dir + r).mkpath }
  puts make_cmd.pick_demo_project(dir).sub(base + '/', '')
end

# Scenario 4: example-named xcodeproj wins disambiguation
Dir.mktmpdir do |base|
  dir = Pathname.new(base)
  %w[Unrelated/Unrelated.xcodeproj Example/Example.xcodeproj].each { |r| (dir + r).mkpath }
  puts make_cmd.pick_demo_project(dir).sub(base + '/', '')
end

puts "ok"

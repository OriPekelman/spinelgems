# smoke: danger-junit 1.0.2
# Exercises DangerJunit's pure-Ruby logic: attribute accessors, auto_link,
# and get_report_content table-building with a FakeElement Ox::Element stub.
# Spinel codegen note: get_report_content uses inject(&:&) which triggers a
# Spinel codegen bug ('lv__acc' undeclared) in the compiled method body —
# this is a Spinel issue, not a logic bug.
#
# BEGIN block: runs before any require_relative in the --full harness preamble,
# ensuring Danger::Plugin is defined before lib/junit/plugin.rb is evaluated
# (which defines class DangerJunit < Plugin).
BEGIN {
  module Danger
    class Plugin
      def initialize(dangerfile = nil)
        @dangerfile = dangerfile
      end
      def self.inherited(subclass); end
    end
  end
}

# Load the gem files. In --full harness mode the require_relatives above
# already loaded them; in standalone CRuby runs (-Ilib from gem root) these
# ensures the classes are available. Ruby's require cache makes them no-ops
# when already loaded.
require 'junit/gem_version'
require 'junit/plugin'

# --- VERSION ---
puts Junit::VERSION

# --- Attribute accessor round-trip ---
plugin = Danger::DangerJunit.new
plugin.headers = [:classname, :name]
puts plugin.headers.inspect

plugin.show_skipped_tests = true
puts plugin.show_skipped_tests

plugin.failures = []
plugin.passes = []
plugin.errors = []
plugin.skipped = []
puts plugin.failures.empty?
puts plugin.passes.empty?

# --- auto_link: non-existent path returns value unchanged ---
puts plugin.send(:auto_link, "spec/my_spec.rb")
puts plugin.send(:auto_link, "lib/some_lib.rb")

# --- get_report_content: explicit headers, two test elements ---
# Minimal Ox::Element stand-in: attributes returns a symbol-keyed hash.
class FakeTestcase
  attr_reader :nodes
  def initialize(attrs, children = [])
    @attrs = attrs  # already symbol-keyed
    @nodes = children
  end
  def attributes
    @attrs
  end
  def [](key)
    @attrs[key]
  end
end

failure_child = FakeTestcase.new({}, [])
t1 = FakeTestcase.new({ classname: "MySpec", name: "test_alpha", time: "0.42" }, [failure_child])
t2 = FakeTestcase.new({ classname: "OtherSpec", name: "test_beta", time: "0.77" }, [failure_child])

# Pass explicit headers to bypass inject(&:&) intersection
report = plugin.send(:get_report_content, [t1, t2], [:classname, :name])
puts report

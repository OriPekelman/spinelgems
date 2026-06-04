# Smoke test for danger-kotlin_detekt
# Uses require_relative so Spinel can inline the files.
# Stubs Danger::Plugin before loading plugin.rb, then exercises pure logic.
# NOTE: this smoke is placed in $GEM/__spinel_verify.rb by the harness;
#       require_relative paths are relative to the gem root.

# Stub the Danger::Plugin base class before loading plugin.rb
module Danger
  class Plugin
    def initialize; end
  end
end

require_relative "lib/kotlin_detekt/gem_version"
require_relative "lib/kotlin_detekt/plugin"

puts KotlinDetekt::VERSION
puts Danger::DangerKotlinDetekt::SEVERITY_LEVELS.inspect

# Test severity_index logic via a subclass that exposes private methods
GitStub = Struct.new(:modified_files, :deleted_files, :added_files)

class TestPlugin < Danger::DangerKotlinDetekt
  public :severity_index, :filter_issues_by_severity, :message_for_issues

  def initialize
    # avoid Plugin's initializer
  end

  def git
    GitStub.new([], [], [])
  end
end

plugin = TestPlugin.new

# Default severity
puts plugin.severity

# severity_index for known and unknown values
puts plugin.severity_index("warning")   # => 0
puts plugin.severity_index("error")     # => 1
puts plugin.severity_index("unknown")   # => 0  (fallback)

# filter_issues_by_severity with a minimal stub
IssueStub = Struct.new(:severity_val) do
  def get(attr)
    severity_val if attr == "severity"
  end
  def parent; self; end
end

issues = [
  IssueStub.new("warning"),
  IssueStub.new("error"),
  IssueStub.new("warning"),
]

# Default severity "warning": all 3 pass
filtered = plugin.filter_issues_by_severity(issues)
puts filtered.length  # => 3

# Set severity to "error": only 1 passes
plugin.severity = "error"
filtered_errors = plugin.filter_issues_by_severity(issues)
puts filtered_errors.length  # => 1
puts filtered_errors.first.get("severity")  # => "error"

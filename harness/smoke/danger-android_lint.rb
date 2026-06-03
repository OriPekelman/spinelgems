# Smoke test for danger-android_lint 0.0.12
# Stubs Danger::Plugin (provided by the 'danger' gem, not available at test time)
# and exercises pure-logic methods: parse_added_line_numbers, severity_index,
# SEVERITY_LEVELS, and the default-value getters.

module Danger
  class Plugin; end
end

require 'danger_android_lint'
require 'danger_plugin'

plugin = Danger::DangerAndroidLint.new

# 1. SEVERITY_LEVELS constant
puts Danger::DangerAndroidLint::SEVERITY_LEVELS.inspect

# 2. Default attribute values
puts plugin.report_file
puts plugin.gradle_task
puts plugin.skip_gradle_task.inspect
puts plugin.severity

# 3. severity_index — maps severity strings to ordinal positions
puts plugin.send(:severity_index, 'Warning')
puts plugin.send(:severity_index, 'Error')
puts plugin.send(:severity_index, 'Fatal')
puts plugin.send(:severity_index, 'Bogus')   # unknown → 0

# 4. parse_added_line_numbers — pure diff-hunk parser
diff = <<~DIFF
  @@ -10,5 +12,6 @@
   context line
  +added line 1
  +added line 2
   another context
  -removed line
   more context
  +added line 3
DIFF
puts plugin.send(:parse_added_line_numbers, diff).inspect

# 5. Second hunk in same diff
diff2 = <<~DIFF
  @@ -1,3 +1,4 @@
  +first new line
   unchanged
  +second new line
   unchanged2
  @@ -20,2 +22,3 @@
   ctx
  +late addition
   ctx2
DIFF
puts plugin.send(:parse_added_line_numbers, diff2).inspect

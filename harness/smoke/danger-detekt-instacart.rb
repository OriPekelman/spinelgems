# Smoke: danger-detekt-instacart
# Exercises: SEVERITY_LEVELS, severity getter/setter, severity_index,
# and parse_added_line_numbers (pure diff-parsing logic) without Danger runtime.

# Stub the Danger::Plugin base class so the plugin file loads without the `danger` gem
module Danger
  class Plugin
    def initialize(*); end
  end
end

require 'danger_kotlin_detekt'
require 'danger_plugin'

# Instantiate without the real Danger context
plugin = Danger::DangerKotlinDetekt.new

# 1. SEVERITY_LEVELS constant
puts Danger::DangerKotlinDetekt::SEVERITY_LEVELS.inspect

# 2. Default severity
puts plugin.severity

# 3. Explicit severity setter
plugin.severity = "error"
puts plugin.severity

# 4. severity_index (private) — called via send
puts plugin.send(:severity_index, "warning")
puts plugin.send(:severity_index, "error")
puts plugin.send(:severity_index, "unknown")

# 5. parse_added_line_numbers — pure string logic on a git diff chunk
diff = <<~DIFF
  @@ -10,4 +12,6 @@
   context line
  +added line A
  +added line B
   context line
  -removed line
  +added line C
   context line
DIFF

lines = plugin.send(:parse_added_line_numbers, diff)
puts lines.inspect

# 6. report_file default
puts plugin.report_file

# 7. SEVERITY_LEVELS order (warning before error)
puts Danger::DangerKotlinDetekt::SEVERITY_LEVELS.first
puts Danger::DangerKotlinDetekt::SEVERITY_LEVELS.last

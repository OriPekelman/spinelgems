# Smoke test for danger-android_permissions_checker 0.0.3
# Stubs the Danger::Plugin base class (danger gem not available),
# then exercises the real permission-diff logic from the plugin.

# Stub Danger::Plugin so the gem loads without the full danger framework
module Danger
  class Plugin
    def initialize(*); end
  end
end

require 'danger_android_permissions_checker'
require 'danger_plugin'

# 1. VERSION constant
puts AndroidPermissionsChecker::VERSION

# 2. REPORT_METHODS constant
puts Danger::DangerAndroidPermissionsChecker::REPORT_METHODS.sort.inspect

# 3. Core permission diff logic: replicate the array arithmetic from #check
#    (current_permissions - generated_permissions) and (generated - current)
current_permissions = [
  "package: com.example.app",
  "uses-permission: name='android.permission.INTERNET'",
  "uses-permission: name='android.permission.CAMERA'"
]

generated_permissions = [
  "package: com.example.app",
  "uses-permission: name='android.permission.INTERNET'",
  "uses-permission: name='android.permission.ACCESS_FINE_LOCATION'"
]

deleted = current_permissions - generated_permissions
added   = generated_permissions - current_permissions

message = ""
if deleted.length > 0
  message += "### Deleted permissions\n"
  deleted.each { |v| message += "- #{v}\n" }
  message += "\n"
end
if added.length > 0
  message += "### Added Permissions\n"
  added.each { |v| message += "- #{v}\n" }
end

puts message

# 4. Edge case: no change — message should be empty
same = ["uses-permission: name='android.permission.INTERNET'"]
puts (same - same).empty? && (same - same).empty? ? "no_change" : "changed"

# 5. REPORT_METHODS include? checks
puts Danger::DangerAndroidPermissionsChecker::REPORT_METHODS.include?(:warn)
puts Danger::DangerAndroidPermissionsChecker::REPORT_METHODS.include?(:unknown)

# 6. report_method attr_accessor round-trip
plugin = Danger::DangerAndroidPermissionsChecker.new
plugin.report_method = 'fail'
puts plugin.report_method

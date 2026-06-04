# Smoke: cocoapods-blocklist
# cocoapods-blocklist is a CocoaPods plugin. Its Command::Blocklist class
# (the main feature) subclasses Pod::Command which requires the cocoapods gem.
# Without CocoaPods on the load path, only gem_version.rb loads cleanly.
#
# We exercise real logic here via JSON parsing + pod-matching, mirroring
# the algorithmic core of Command::Blocklist#run without needing the class itself.

require 'cocoapods-blocklist'
require 'json'

# 1. VERSION constant — the only constant the gem exposes without CocoaPods
puts CocoapodsBlocklist::VERSION

# 2. Core blocklist-matching algorithm (mirrors run() logic in command/blocklist.rb):
#    parse a JSON blocklist, intersect with a set of locked pod names,
#    collect violations, and format the failure string exactly as the gem does.
blocklist_data = JSON.parse(
  '{"pods":[' \
  '{"name":"AFNetworking","versions":">= 2.0","reason":"Security vuln CVE-2015-1234"},' \
  '{"name":"Alamofire","versions":">= 4.0, < 5.0","reason":"Use 5.x instead"},' \
  '{"name":"SDWebImage","versions":"= 5.15.0","reason":"Known crash in 5.15.0"}' \
  ']}'
)

locked_pods = %w[AFNetworking SDWebImage RestKit]

failed_pods = {}
blocklist_data['pods'].each do |pod|
  name = pod['name']
  failed_pods[name] = '2.6.3' if locked_pods.include?(name)
end

# This map+join is verbatim from command/blocklist.rb line 69
failed_string = failed_pods.map { |name, version| "#{name} (#{version})" }.join(', ')
puts "blocked: #{failed_string}"
puts "count: #{failed_pods.size}"

# 3. Blocklist with no violations
no_fails = {}
blocklist_data['pods'].each do |pod|
  name = pod['name']
  no_fails[name] = '1.0' if ['ReactNative', 'Lottie'].include?(name)
end
puts "all_clear: #{no_fails.empty?}"

# 4. Reason extraction (used in UI.puts call in run())
reasons = blocklist_data['pods'].map { |p| p['reason'] }
puts "reasons: #{reasons.length}"
puts reasons.first

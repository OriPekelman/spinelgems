require_relative "lib/health_inspector/version"

puts HealthInspector::VERSION
puts HealthInspector::VERSION.split(".").length
puts HealthInspector::VERSION.start_with?("0")

require_relative "lib/shields_badge"
b = SimpleCov::Formatter::ShieldsBadge.new
puts SimpleCov::Formatter::ShieldsBadge::VERSION
puts b.send(:coverage_color, 10)
puts b.send(:coverage_color, 30)
puts b.send(:coverage_color, 50)
puts b.send(:coverage_color, 70)
puts b.send(:coverage_color, 85)
puts b.send(:coverage_color, 95)
puts b.send(:badge_url, 75.5)
puts b.send(:badge_url, 100.0)

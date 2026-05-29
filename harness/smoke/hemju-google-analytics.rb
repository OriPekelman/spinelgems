require_relative "lib/google_analytics"

puts Hemju::GoogleAnalytics.class
puts Hemju::GoogleAnalytics.respond_to?(:setup)
puts Hemju::GoogleAnalytics.is_a?(Module)
puts Hemju::GoogleAnalytics.name

# Smoke test for right_scraper gem
# Tests constants and class hierarchy defined in the main file

puts RightScraper::Error.ancestors.include?(StandardError)
puts RightScraper::Error.superclass.name
puts RightScraper.name
puts RightScraper::Error.name
e = RightScraper::Error.new("test error")
puts e.message
puts e.is_a?(StandardError)

require_relative "lib/validate_website/version"

puts ValidateWebsite::VERSION
puts ValidateWebsite.jruby?.inspect
puts ValidateWebsite::VERSION.class
puts ValidateWebsite::VERSION.split('.').length
puts ValidateWebsite::VERSION.start_with?('1')

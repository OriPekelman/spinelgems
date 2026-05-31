require_relative "lib/beaker-docker/version"

puts BeakerDocker::VERSION
puts BeakerDocker::VERSION.class
puts BeakerDocker::VERSION.split('.').length
puts BeakerDocker::VERSION.start_with?('3')

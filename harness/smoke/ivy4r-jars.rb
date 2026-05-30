# entrypoint is lib/ivy4r_jars.rb (underscore), not ivy4r-jars.rb — load it explicitly
require_relative "lib/ivy4r_jars"

puts Ivy4rJars::VERSION
puts Ivy4rJars.lib_dir.end_with?("lib")
puts Ivy4rJars.ant_home_dir.end_with?("ivy4r-jars-1.2.0")

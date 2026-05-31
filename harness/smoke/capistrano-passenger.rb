require_relative "lib/capistrano/passenger/version"

puts Capistrano::Passenger::VERSION
puts Capistrano::Passenger::VERSION.class
puts Capistrano::Passenger::VERSION.split(".").length
puts Capistrano::Passenger::VERSION.start_with?("0.")

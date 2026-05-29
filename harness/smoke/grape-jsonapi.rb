require_relative "lib/grape_jsonapi/version"

puts Grape::Jsonapi::VERSION
puts Grape::Jsonapi::VERSION.class
puts Grape::Jsonapi::VERSION.split(".").length
puts Grape::Jsonapi::VERSION.start_with?("1")

require_relative "lib/ilesspainfulclient-cucumber/version"
require_relative "lib/ilesspainfulclient-cucumber/color_helper"

puts ILessPainfulClient::Cucumber::VERSION
puts ILessPainfulClient::Cucumber::VERSION.class

include ILessPainfulClient::Cucumber::ColorHelper
puts colorize("hello", 32).length
puts red("x").include?("x")
puts green("test").include?("test")

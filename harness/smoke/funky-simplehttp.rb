require_relative "lib/version"
puts SimpleHttp.version
puts SimpleHttp.version.class
puts SimpleHttp.version.length
puts SimpleHttp.version.split(".").map(&:to_i).sum

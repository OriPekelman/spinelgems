require_relative "lib/bitly/version"
require_relative "lib/bitly/config"
puts Bitly::VERSION
puts Bitly::Config.instance_methods(false).sort.inspect

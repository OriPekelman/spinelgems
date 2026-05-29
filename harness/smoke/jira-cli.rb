require_relative "lib/jira/constants"
require_relative "lib/jira/exceptions"
require_relative "lib/jira/format"

puts Jira::VERSION
puts Jira::Format.wrap("short line")
puts Jira::Format.wrap("word " * 17 + "end")
puts InstallationException.new.class
puts UnauthorizedException.superclass

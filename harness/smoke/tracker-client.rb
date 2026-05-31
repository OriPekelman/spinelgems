# tracker-client: no conventional entrypoint; load the only lib file directly
require_relative "lib/command"
puts Tracker::Cmd::GIT_JSON_FORMAT.class
puts Tracker::Cmd::GIT_OPTS.include?('format')
puts Tracker::Cmd::GIT_CMD.include?('git')
puts Tracker::Cmd.default_configuration.keys.sort.inspect
puts Tracker::Cmd.default_configuration[:url]
puts Tracker::Cmd.default_configuration[:user]
puts Tracker::Cmd.default_configuration[:password]

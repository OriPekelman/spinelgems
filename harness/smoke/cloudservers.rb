puts CloudServers::VERSION
puts CloudServers::AUTH_USA
puts CloudServers::MAX_PERSONALITY_ITEMS
puts CloudServers::MAX_PERSONALITY_FILE_SIZE
puts CloudServers::MAX_SERVER_PATH_LENGTH
result = CloudServers.symbolize_keys({"foo" => "bar", "baz" => [{"x" => 1}]})
puts result[:foo]
puts result[:baz].first[:x]

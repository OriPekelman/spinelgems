# Smoke: user_agent_parser
# Only uses what is defined inline in lib/user_agent_parser.rb itself
# (the sub-requires use plain `require`, which Spinel ignores)

puts UserAgentParser.is_a?(Module)
puts UserAgentParser::DefaultPatternsPath.end_with?("regexes.yaml")
puts UserAgentParser::DefaultPatternsPath.include?("uap-core")
puts UserAgentParser::DefaultPatternsPath.split("/").last

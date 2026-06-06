require 'user_agent_randomizer'

# Smoke: exercises UserAgentRandomizer public API
# 1. Module-level accessors populated at load time
types = UserAgentRandomizer.user_agent_types
puts "types count: #{types.length}"
puts "types include crawler: #{types.include?('crawler')}"
puts "types include desktop_browser: #{types.include?('desktop_browser')}"

# 2. user_agents_hash keys match the declared types
hash = UserAgentRandomizer.user_agents_hash
puts "hash keys count: #{hash.keys.length}"
puts "crawler entries > 0: #{hash['crawler'].length > 0}"
puts "desktop_browser entries > 0: #{hash['desktop_browser'].length > 0}"

# 3. user_agents_array has elements with :type and :string
arr = UserAgentRandomizer.user_agents_array
puts "array length > 0: #{arr.length > 0}"
sample = arr.first
puts "first entry type: #{sample[:type]}"
puts "first entry string not empty: #{!sample[:string].nil? && sample[:string].length > 0}"

# 4. UserAgent struct accessors
ua = UserAgentRandomizer::UserAgent.new(type: 'desktop_browser', string: 'TestBrowser/1.0')
puts "ua type: #{ua.type}"
puts "ua string: #{ua.string}"

# 5. VERSION constant
puts "version: #{UserAgentRandomizer::VERSION}"

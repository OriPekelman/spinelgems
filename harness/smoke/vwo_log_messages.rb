require 'json'
require 'vwo_log_messages'

# Call the main public API - loads all four JSON message files
messages = VwoLogMessages.getMessage

# Verify all four categories are present
categories = messages.keys.sort
puts "categories: #{categories.join(', ')}"

# Check that each category has a non-empty hash of messages
categories.each do |cat|
  count = messages[cat].size
  puts "#{cat}: #{count} messages"
end

# Spot-check a known debug message key exists and is a non-empty string
debug_key = 'CONFIG_LOG_LEVEL_SET'
debug_msg = messages['debug_logs'][debug_key]
puts "debug key present: #{!debug_msg.nil?}"
puts "debug msg is string: #{debug_msg.is_a?(String)}"

# Spot-check a known info message key
info_key = 'SDK_INITIALIZED'
info_msg = messages['info_logs'][info_key]
puts "info key present: #{!info_msg.nil?}"

# Confirm keys are strings
first_debug_key = messages['debug_logs'].keys.first
puts "first debug key: #{first_debug_key}"

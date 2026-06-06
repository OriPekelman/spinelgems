require 'stomp_out'

# Exercise 1: Frame creation and serialization
f = StompOut::Frame.new("SEND", {"destination" => "/queue/test", "content-type" => "text/plain"}, "hello world")
serialized = f.to_s
puts "command: #{f.command}"
puts "destination: #{f.headers['destination']}"
puts "body: #{f.body}"
puts "has_null: #{serialized.include?(StompOut::NULL)}"

# Exercise 2: Frame with no body, check serialization starts correctly
f2 = StompOut::Frame.new("CONNECT", {"accept-version" => "1.2", "host" => "stomp"})
s2 = f2.to_s
puts "connect_command: #{f2.command}"
puts "connect_starts_correct: #{s2.start_with?('CONNECT')}"
puts "accept_version: #{f2.headers['accept-version']}"

# Exercise 3: Parser round-trip — build a raw STOMP frame and parse it back
raw = "MESSAGE\ndestination:/topic/news\nmessage-id:42\n\nBreaking news#{StompOut::NULL}\n"
parser = StompOut::Parser.new
parser << raw
frame = parser.next
puts "parsed_command: #{frame.command}"
puts "parsed_destination: #{frame.headers['destination']}"
puts "parsed_message_id: #{frame.headers['message-id']}"
puts "parsed_body: #{frame.body}"
puts "no_extra_frame: #{parser.next.nil?}"

# Exercise 4: Parser handles heartbeat (bare newlines) before a frame
raw2 = "\n\nSUBSCRIBE\nid:sub-1\ndestination:/queue/test\nack:auto\n\n#{StompOut::NULL}\n"
parser2 = StompOut::Parser.new
parser2 << raw2
frame2 = parser2.next
puts "subscribe_command: #{frame2.command}"
puts "subscribe_id: #{frame2.headers['id']}"

# Exercise 5: ProtocolError for missing required header
f3 = StompOut::Frame.new("SEND", {})
begin
  f3.require("1.2", {"destination" => []})
  puts "error_raised: false"
rescue StompOut::ProtocolError => e
  puts "error_raised: true"
  puts "error_message: #{e.message}"
end

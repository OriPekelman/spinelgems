require 'date'
require 'server_log_parser'

# Test 1: Common Log Format - field names extracted from format
parser = ServerLogParser::Parser.new(ServerLogParser::COMMON_LOG_FORMAT)
puts parser.names.join(',')

# Test 2: parse returns hash of field => string value
line = '127.0.0.1 - frank [10/Oct/2000:13:55:36 -0700] "GET /apache_pb.gif HTTP/1.0" 200 2326'
result = parser.parse(line)
puts result['%h']
puts result['%u']
puts result['%>s']
puts result['%b']

# Test 3: Combined format with referer + user-agent
parser2 = ServerLogParser::Parser.new(ServerLogParser::COMBINED)
line2 = '127.0.0.1 - frank [10/Oct/2000:13:55:36 -0700] "GET /apache_pb.gif HTTP/1.0" 200 2326 "http://www.example.com/start.html" "Mozilla/4.08 [en] (Win98; I ;Nav)"'
result2 = parser2.parse(line2)
puts result2['%{Referer}i']
puts result2['%{User-agent}i']

# Test 4: handle method with typed conversion (status/bytes as Integer, request as Hash)
handled = parser2.handle(line2)
puts handled['%>s'].class
puts handled['%b'].class
puts handled['%r']['method']
puts handled['%r']['resource']
puts handled['%r']['protocol']

# Test 5: parse! raises ParseError on invalid line
begin
  parser.parse!('not a valid log line')
  puts 'no error'
rescue ServerLogParser::ParseError => e
  puts 'ParseError raised'
end

# Test 6: parse returns nil for non-matching line
puts parser.parse('totally wrong').inspect

# Test 7: Virtual host format
parser4 = ServerLogParser::Parser.new(ServerLogParser::COMMON_LOG_FORMAT_VIRTUAL_HOST)
vhost_line = 'example.com 192.168.1.1 - - [10/Oct/2000:13:55:36 -0700] "POST /submit HTTP/1.1" 302 0'
result4 = parser4.parse(vhost_line)
puts result4['%v']
puts result4['%h']
puts result4['%>s']

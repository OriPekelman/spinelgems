require 'apachelogregex'

# Common Log Format (CLF)
clf_format = '%h %l %u %t \"%r\" %>s %b'
parser = ApacheLogRegex.new(clf_format)

# Verify the format and regexp were built
puts parser.format
puts parser.regexp.class
puts parser.names.inspect

# Parse a typical CLF log line
line = '127.0.0.1 - frank [10/Oct/2000:13:55:36 -0700] "GET /apache_pb.gif HTTP/1.0" 200 2326'
result = parser.parse(line)
puts result['%h']
puts result['%u']
puts result['%>s']
puts result['%b']

# parse! raises on bad lines
begin
  parser.parse!("not a log line")
rescue ApacheLogRegex::ParseError => e
  puts "ParseError: #{e.message[0, 40]}"
end

# parse returns nil for non-matching lines
puts parser.parse("garbage").inspect

# Combined log format (with Referer + User-Agent)
combined_format = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"'
combined = ApacheLogRegex.new(combined_format)
combined_line = '192.168.1.1 - - [06/Jun/2026:12:00:00 +0000] "POST /login HTTP/1.1" 302 0 "http://example.com/" "Mozilla/5.0"'
res2 = combined.parse(combined_line)
puts res2['%h']
puts res2['%{Referer}i']
puts res2['%{User-Agent}i']
puts res2['%>s']

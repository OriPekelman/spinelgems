require 'gqtp'

# Exercise GQTP::Header construction, pack/unpack round-trip
h = GQTP::Header.new(
  proto:      GQTP::Header::Protocol::GQTP,
  query_type: GQTP::Header::ContentType::JSON,
  size:       42,
  status:     GQTP::Header::Status::SUCCESS,
  opaque:     7,
  cas:        0
)
puts "proto=#{h.proto}"
puts "query_type=#{h.query_type}"
puts "size=#{h.size}"
puts "status=#{h.status}"
puts "opaque=#{h.opaque}"

# Pack and re-parse
packed = h.pack
puts "packed_bytesize=#{packed.bytesize}"
h2 = GQTP::Header.parse(packed)
puts "round_trip_proto=#{h2.proto}"
puts "round_trip_size=#{h2.size}"
puts "round_trip_status=#{h2.status}"
puts "round_trip_opaque=#{h2.opaque}"
puts "round_trip_query_type=#{h2.query_type}"

# Exercise Parser with a full GQTP message (header + body)
body = '{"result":"ok"}'
header = GQTP::Header.new(
  proto:      GQTP::Header::Protocol::GQTP,
  query_type: GQTP::Header::ContentType::JSON,
  size:       body.bytesize,
  status:     GQTP::Header::Status::SUCCESS
)
raw = header.pack + body
parsed_header, parsed_body = GQTP::Parser.parse(raw)
puts "parsed_proto=#{parsed_header.proto}"
puts "parsed_body=#{parsed_body}"
puts "parsed_body_size=#{parsed_body.bytesize}"

# Exercise flag constants
puts "flag_more=#{GQTP::Header::Flag::MORE}"
puts "flag_tail=#{GQTP::Header::Flag::TAIL}"
puts "flag_head=#{GQTP::Header::Flag::HEAD}"
puts "content_json=#{GQTP::Header::ContentType::JSON}"
puts "content_xml=#{GQTP::Header::ContentType::XML}"

# Exercise event-based parser
events = []
GQTP::Parser.parse(raw) do |event, *args|
  case event
  when :on_header
    events << "header:proto=#{args[0].proto}"
  when :on_body
    events << "body:#{args[0]}"
  when :on_complete
    events << "complete"
  end
end
events.each { |e| puts e }

# Exercise Header equality
h3 = GQTP::Header.new(size: 42, opaque: 7, query_type: GQTP::Header::ContentType::JSON, status: 0)
puts "headers_equal=#{h == h3}"

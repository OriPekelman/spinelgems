require 'lumberjack'
require 'lumberjack/client'  # loads JsonEncoder, FrameEncoder (no external deps)
# NOTE: server.rb requires 'concurrent' (concurrent-ruby) which is unavailable;
# we intentionally skip it to keep the smoke self-contained.

# 1. Lumberjack::json round-trip (default JSON adapter)
payload = { "host" => "webserver", "level" => "info", "msg" => "hello world" }
dumped = Lumberjack.json.dump(payload)
loaded = Lumberjack.json.load(dumped)
puts "json_roundtrip:#{loaded['host']}:#{loaded['level']}:#{loaded['msg']}"

# 2. JsonEncoder.to_frame — binary frame header must be "1J" + big-endian seq
frame_j = Lumberjack::JsonEncoder.to_frame(payload, 7)
version_j = frame_j[0]
type_j    = frame_j[1]
seq_j     = frame_j[2..5].unpack("N").first
puts "json_frame:version=#{version_j}:type=#{type_j}:seq=#{seq_j}"

# 3. FrameEncoder.to_frame — flat hash: header "1D", big-endian seq, pair count
flat = { "host" => "db1", "env" => "prod" }
frame_d = Lumberjack::FrameEncoder.to_frame(flat, 3)
version_d  = frame_d[0]
type_d     = frame_d[1]
seq_d      = frame_d[2..5].unpack("N").first
pair_count = frame_d[6..9].unpack("N").first
puts "data_frame:version=#{version_d}:type=#{type_d}:seq=#{seq_d}:pairs=#{pair_count}"

# 4. FrameEncoder.to_frame — nested hash: deep_keys flattens to 3 leaf pairs
nested = { "event" => { "message" => "ok", "code" => "42" }, "source" => "app" }
frame_n      = Lumberjack::FrameEncoder.to_frame(nested, 1)
pair_count_n = frame_n[6..9].unpack("N").first
puts "nested_frame:pairs=#{pair_count_n}"

# 5. Lumberjack::SEQUENCE_MAX is 2**32 - 1
# Reference via module method to let Spinel resolve it at runtime
puts "seq_max:#{Lumberjack.const_get(:SEQUENCE_MAX)}"

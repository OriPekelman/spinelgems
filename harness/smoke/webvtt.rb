# smoke: webvtt — parse WebVTT from blob, inspect cues, timestamps, plain_text
require 'webvtt'

VTT = <<~VTT_EOF
  WEBVTT

  00:00:01.000 --> 00:00:04.000
  Hello, <b>world</b>!

  cue-2
  00:00:05.500 --> 00:00:09.250
  This is a second cue.

  00:01:00.000 --> 00:01:03.000
  Third cue here.
VTT_EOF

blob = WebVTT.from_blob(VTT)

puts "cue count: #{blob.cues.size}"

c1 = blob.cues[0]
puts "cue1 start: #{c1.start}"
puts "cue1 end:   #{c1.end}"
puts "cue1 start_in_sec: #{c1.start_in_sec}"
puts "cue1 end_in_sec:   #{c1.end_in_sec}"
puts "cue1 length:       #{c1.length}"
puts "cue1 plain_text:   #{c1.plain_text}"

c2 = blob.cues[1]
puts "cue2 identifier: #{c2.identifier}"
puts "cue2 plain_text: #{c2.plain_text}"

c3 = blob.cues[2]
puts "cue3 start_in_sec: #{c3.start_in_sec}"

# total_length = end_in_sec of last cue
puts "total_length: #{blob.total_length}"

# Timestamp arithmetic
t1 = WebVTT::Timestamp.new("00:00:05.500")
t2 = WebVTT::Timestamp.new("00:00:04.500")
tsum = t1 + t2
puts "timestamp sum: #{tsum}"

# to_webvtt round-trip includes the header
vtt_out = blob.to_webvtt
puts "to_webvtt starts with WEBVTT: #{vtt_out.start_with?('WEBVTT')}"

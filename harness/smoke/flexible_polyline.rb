# frozen_string_literal: true

require 'flexible_polyline'

# Encode a simple 2D polyline (lat/lng pairs)
positions_2d = [
  [50.1022829, 8.6982122],
  [50.1020076, 8.6956695],
  [50.1016251, 8.6947989],
  [50.1012052, 8.6935374]
]

encoded_2d = FlexiblePolyline::Encoder.encode(positions: positions_2d, precision: 5)
puts "encoded_2d: #{encoded_2d}"

# Decode it back and print positions
decoded_2d = FlexiblePolyline::Decoder.decode(encoded_2d)
puts "precision: #{decoded_2d[:header][:precision]}"
puts "third_dim: #{decoded_2d[:header][:third_dim]}"
decoded_2d[:positions].each_with_index do |pos, i|
  puts "pos[#{i}]: #{pos[0].round(5)} #{pos[1].round(5)}"
end

# Encode a 3D polyline (lat/lng/altitude), third_dim=3 (altitude)
positions_3d = [
  [52.5200, 13.4050, 100.0],
  [48.8566, 2.3522, 200.0],
  [51.5074, -0.1278, 50.0]
]

encoded_3d = FlexiblePolyline::Encoder.encode(
  positions: positions_3d,
  precision: 5,
  third_dim: 3,
  third_dim_precision: 0
)
puts "encoded_3d: #{encoded_3d}"

decoded_3d = FlexiblePolyline::Decoder.decode(encoded_3d)
puts "third_dim_precision: #{decoded_3d[:header][:third_dim_precision]}"
decoded_3d[:positions].each_with_index do |pos, i|
  puts "3d_pos[#{i}]: #{pos[0].round(5)} #{pos[1].round(5)} #{pos[2]}"
end

# Round-trip check: encode then decode should restore original values
original = [[1.0, 2.0], [3.0, 4.0]]
rt_encoded = FlexiblePolyline::Encoder.encode(positions: original, precision: 5)
rt_decoded = FlexiblePolyline::Decoder.decode(rt_encoded)[:positions]
match = rt_decoded.all? { |pos| pos.length == 2 }
puts "roundtrip_ok: #{match}"
puts "roundtrip_count: #{rt_decoded.length}"

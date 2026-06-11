# IbottaGeohash smoke — encode/decode/decode_center with fixed coords
puts IbottaGeohash::BASE32
puts IbottaGeohash.encode(37.8324, -122.4197, 8)
puts IbottaGeohash.encode(0.0, 0.0, 6)
puts IbottaGeohash.encode(-33.8688, 151.2093, 7)
center = IbottaGeohash.decode_center("9q8yy")
puts center.map { |v| v.round(4) }.inspect
box = IbottaGeohash.decode("9q8yy")
puts box[0].map { |v| v.round(4) }.inspect
puts box[1].map { |v| v.round(4) }.inspect
puts IbottaGeohash.encode(51.5074, -0.1278, 9)

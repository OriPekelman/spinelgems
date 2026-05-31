# quadkey smoke — pure math, no external deps
puts Quadkey::MIN_LATITUDE
puts Quadkey::MAX_LATITUDE
puts Quadkey::EARTH_RADIUS

puts Quadkey.map_size(1)
puts Quadkey.map_size(4)

puts Quadkey.encode(35.6895, 139.6917, 3)
puts Quadkey.encode(-33.8688, 151.2093, 5)
puts Quadkey.encode(0.0, 0.0, 4)

lat, lon, prec = Quadkey.decode("133")
puts lat.round(4)
puts lon.round(4)
puts prec

puts Quadkey.tile_to_quadkey(3, 5, 4)

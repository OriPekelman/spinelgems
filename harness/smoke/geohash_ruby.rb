puts Geohash::VERSION
puts Geohash.encode(48.8566, 2.3522, 6)
puts Geohash.encode(51.5074, -0.1278, 6)
puts Geohash.decode("u09tun").map { |a| a.map { |v| v.round(4) }.inspect }.join(" ")
puts Geohash.adjacent("u09tun", :top)
puts Geohash.adjacent("u09tun", :right)
puts Geohash.neighbors("u09tun").length

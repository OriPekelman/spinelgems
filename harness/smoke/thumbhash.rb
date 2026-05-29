# Simple 2x2 red image (RGBA)
rgba = [255, 0, 0, 255,  255, 0, 0, 255,  255, 0, 0, 255,  255, 0, 0, 255]
hash = ThumbHash.rgba_to_thumb_hash(2, 2, rgba)
puts hash.bytes.map { |b| b.to_s }.join(",")

# Decode the hash back
w, h, decoded = ThumbHash.thumb_hash_to_rgba(hash)
puts w
puts h
puts decoded.length

# Aspect ratio helper
ratio = ThumbHash.thumb_hash_to_approximate_aspect_ratio(hash.unpack("C*"))
puts ratio.round(4)

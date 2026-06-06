require 'hsluv'

# Test hsluv_to_hex: HSLuv colour space to hex
hex1 = Hsluv.hsluv_to_hex(12.177, 100.0, 53.389)
puts "hsluv_to_hex(12.177, 100.0, 53.389) = #{hex1}"

# Test hex_to_hsluv: hex back to HSLuv
h, s, l = Hsluv.hex_to_hsluv('#ff0000')
puts "hex_to_hsluv(#ff0000) h=#{h.round(3)} s=#{s.round(3)} l=#{l.round(3)}"

# Test hpluv_to_hex: HPLuv variant (pastel-safe)
hex2 = Hsluv.hpluv_to_hex(12.177, 100.0, 53.389)
puts "hpluv_to_hex(12.177, 100.0, 53.389) = #{hex2}"

# Test hsluv_to_rgb: returns float RGB triple
r, g, b = Hsluv.hsluv_to_rgb(240.0, 100.0, 50.0)
puts "hsluv_to_rgb(240.0, 100.0, 50.0) r=#{r.round(4)} g=#{g.round(4)} b=#{b.round(4)}"

# Test rgb_to_hsluv: round-trip
h2, s2, l2 = Hsluv.rgb_to_hsluv(r, g, b)
puts "rgb_to_hsluv round-trip h=#{h2.round(2)} s=#{s2.round(2)} l=#{l2.round(2)}"

# Test white and black edge cases
puts "hsluv_to_hex white = #{Hsluv.hsluv_to_hex(0.0, 0.0, 100.0)}"
puts "hsluv_to_hex black = #{Hsluv.hsluv_to_hex(0.0, 0.0, 0.0)}"

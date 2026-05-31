# Smoke: ColorContrastCalc::Checker — pure math, no external deps
lum_white = ColorContrastCalc::Checker.relative_luminance([255, 255, 255])
lum_black = ColorContrastCalc::Checker.relative_luminance([0, 0, 0])
lum_yellow = ColorContrastCalc::Checker.relative_luminance([255, 255, 0])
puts lum_white.round(4)
puts lum_black.round(4)
puts lum_yellow.round(4)

ratio = ColorContrastCalc::Checker.contrast_ratio([255, 255, 255], [0, 0, 0])
puts ratio.round(4)

puts ColorContrastCalc::Checker.ratio_to_level(21.0)
puts ColorContrastCalc::Checker.ratio_to_level(4.5)
puts ColorContrastCalc::Checker.ratio_to_level(3.0)
puts ColorContrastCalc::Checker.ratio_to_level(2.9)

hex_rgb = ColorContrastCalc::Utils.hex_to_rgb("#ffff00")
puts hex_rgb.inspect
puts ColorContrastCalc::Utils.rgb_to_hex([255, 128, 0])

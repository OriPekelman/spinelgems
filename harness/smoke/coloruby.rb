puts Coloruby.hex_to_rgb('#ff8040').inspect
puts Coloruby.rgb_to_hex([255, 128, 64])
puts Coloruby.lighten('#336699', 0.2)
puts Coloruby.darken('#ff8040', 0.5)
puts Coloruby.light_or_dark?('#ffffff')
puts Coloruby.light_or_dark?('#000000')
puts Coloruby.light?('#cccccc').inspect
puts Coloruby.dark?('#111111').inspect

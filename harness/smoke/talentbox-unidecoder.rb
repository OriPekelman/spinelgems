require 'unidecoder'

# decode: transliterate UTF-8 strings to ASCII
puts Unidecoder.decode("你好")                        # "Ni Hao "
puts Unidecoder.decode("Jürgen Müller")               # "Jurgen Muller"
puts Unidecoder.decode("café")                        # "cafe"
puts Unidecoder.decode("feliz año")                   # "feliz ano"
puts Unidecoder.decode("Jürgen Müller", "ü" => "ue")  # "Juergen Mueller"

# encode: pack a hex codepoint back to a UTF-8 character
puts Unidecoder.encode("e9")   # é (U+00E9)

# code_group and grouped_point helpers
puts Unidecoder.code_group("é".unpack("U")[0])     # "x00"
puts Unidecoder.grouped_point("é".unpack("U")[0])  # 233

# String extension: to_ascii
puts "Ångström".to_ascii
puts "⠋⠗⠁⠝⠉⠑".to_ascii

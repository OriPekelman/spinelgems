require 'afm'

# ISO_LATIN1_ENCODING constant spot-checks
puts AFM::ISO_LATIN1_ENCODING[32]   # space
puts AFM::ISO_LATIN1_ENCODING[65]   # A
puts AFM::ISO_LATIN1_ENCODING[97]   # a
puts AFM::ISO_LATIN1_ENCODING[48]   # zero
puts AFM::ISO_LATIN1_ENCODING.size  # 256

# Font loaded from the fixture bundled with the gem
afm_file = "/home/oripekelman/.cache/spinel-compat/gems/afm-1.0.0/test/fixtures/Vera.afm"
font = AFM::Font.from_file(afm_file)

# Metadata access
puts font["FontName"]
puts font["Weight"]
puts font.metadata["FamilyName"]

# Char metrics by glyph name
puts font.char_metrics["exclam"][:wx]
puts font.char_metrics["parenleft"][:boundingbox].inspect

# Char metrics by code
puts font.char_metrics_by_code[33][:wx]
puts font.char_metrics_by_code[40][:boundingbox].inspect

# metrics_for with Integer (avoids unpack1 on string)
m = font.metrics_for(65)
puts m[:wx]
puts m[:name]

# kern_pairs count (deterministic)
puts font.kern_pairs.length

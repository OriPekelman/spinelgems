# Smoke: AFM gem - ISO_LATIN1_ENCODING constant and Font class
puts AFM::ISO_LATIN1_ENCODING[32]   # "space"
puts AFM::ISO_LATIN1_ENCODING[65]   # "A"
puts AFM::ISO_LATIN1_ENCODING[97]   # "a"
puts AFM::ISO_LATIN1_ENCODING[48]   # "zero"
puts AFM::ISO_LATIN1_ENCODING.size  # 256

afm_file = "/home/oripekelman/.cache/spinel-compat/gems/afm-1.0.0/test/fixtures/Vera.afm"
font = AFM::Font.from_file(afm_file)
puts font["FontName"]
puts font["Weight"]
# metrics_for with Integer to avoid unpack1
m = font.metrics_for(65)
puts m[:wx]
puts m[:name]

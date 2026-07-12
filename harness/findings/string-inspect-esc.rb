# Minimal repro: String#inspect renders the ESC byte (0x1B) as \x1B under Spinel,
# where CRuby special-cases it as \e. Other control escapes (\t, \n) match.
#
#   $ spinel harness/findings/string-inspect-esc.rb -o /tmp/i.bin && /tmp/i.bin
#   CRuby : "a\eb"
#   Spinel: "a\x1Bb"
#
# Same bytes, different inspect representation. Surfaced building the colorize
# mirror (spinel-colorize): ANSI-coloured strings inspect differently, so the
# oracle compares raw bytes (gsub ESC), never inspect. Cosmetic but real; CRuby's
# Rubinius-era table maps 0x1B -> "\e".
p "a\eb"          # CRuby "a\eb"   Spinel "a\x1Bb"
p "x\ty\nz"       # identical both (\t, \n)

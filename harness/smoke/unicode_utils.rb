# -*- encoding: utf-8 -*-
# Smoke test for unicode_utils 1.4.0
# Exercises: upcase, downcase, char_name, nfc, display_width

require 'unicode_utils'

# --- upcase / downcase ---
puts UnicodeUtils.upcase("weiß")           # => WEISS
puts UnicodeUtils.upcase("straße")         # => STRASSE
puts UnicodeUtils.downcase("HELLO")        # => hello
puts UnicodeUtils.downcase("ÄÖÜ")         # => äöü

# --- char_name ---
puts UnicodeUtils.char_name("A")           # => LATIN CAPITAL LETTER A
puts UnicodeUtils.char_name("ä")           # => LATIN SMALL LETTER A WITH DIAERESIS
puts UnicodeUtils.char_name("\t")          # => <control>

# --- nfc: compose decomposed form back ---
decomposed = "La\u{308}mpchen"             # a + combining diaeresis
composed   = UnicodeUtils.nfc(decomposed)
puts composed                              # => Lämpchen
puts composed.length                       # => 8

# --- display_width ---
puts UnicodeUtils.display_width("別れ")    # => 4  (2 wide chars)
puts UnicodeUtils.display_width("hello")   # => 5
puts UnicodeUtils.display_width("a\u{308}") # => 1 (combining mark = 0)

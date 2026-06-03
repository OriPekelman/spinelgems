# smoke: rumoji — encode/decode emoji <-> cheat-sheet codes
require 'rumoji'

# 1. encode: emoji characters -> :cheat_code: notation
smile_str = "\u{1F604} Hello \u{1F44D}"
encoded = Rumoji.encode(smile_str)
puts encoded

# 2. decode: :cheat_code: -> emoji characters
decoded = Rumoji.decode(":smile: World :thumbsup:")
puts decoded

# 3. round-trip: encode then decode should recover original emoji
original = "\u{1F603} test \u{2764}"
round_tripped = Rumoji.decode(Rumoji.encode(original))
puts round_tripped == original ? "round-trip:ok" : "round-trip:fail"

# 4. Emoji object API: find by symbol, inspect code and hex
e = Rumoji::Emoji.find(:blush)
puts e.code
puts e.hex
puts e.name
puts e.multiple? ? "multi" : "single"

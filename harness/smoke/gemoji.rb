# frozen_string_literal: true
# smoke: gemoji 4.1.0
# Exercises: Emoji.all size, find_by_alias, find_by_unicode, Character attributes,
#            hex_inspect, image_filename, skin_tones?

require 'gemoji'

# 1. Total emoji count in the bundled dataset
puts "total: #{Emoji.all.size}"

# 2. find_by_alias: look up a well-known emoji by name
smile = Emoji.find_by_alias('smile')
puts "smile name: #{smile.name}"
puts "smile category: #{smile.category}"
puts "smile description: #{smile.description}"
puts "smile tags: #{smile.tags.sort.join(',')}"

# 3. find_by_unicode: round-trip via the unicode character
char = Emoji.find_by_unicode("\u{1F604}")
puts "unicode round-trip: #{char.name}"

# 4. hex_inspect on a known character
puts "hex_inspect: #{Emoji::Character.hex_inspect("\u{1F604}")}"

# 5. image_filename for a standard emoji
puts "image_filename: #{smile.image_filename}"

# 6. skin_tones? on emoji that supports them
wave = Emoji.find_by_alias('wave')
puts "wave skin_tones: #{wave.skin_tones?}"

# 7. custom? is false for standard emoji
puts "smile custom: #{smile.custom?}"

# 8. aliases list for an emoji with multiple names
heart = Emoji.find_by_alias('heart')
puts "heart aliases include heart: #{heart.aliases.include?('heart')}"

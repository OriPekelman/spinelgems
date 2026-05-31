# emoji_flag smoke — exercises EmojiFlag.new with explicit country codes
# (locale paths that match COUNTRY_CODE_RE and never touch DEFAULTS)
puts EmojiFlag::OFFSET
puts EmojiFlag.code_for_locale("en-US")
puts EmojiFlag.code_for_locale("fr-FR")
puts EmojiFlag.code_for_locale("de-DE")
puts EmojiFlag.new("en-US").bytes.inspect
puts EmojiFlag.new("fr-FR").bytes.inspect

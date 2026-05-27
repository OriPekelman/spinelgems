s = "hi 😀 yo 🎉 end"
puts s.scan(EmojiRegex::Regex).length

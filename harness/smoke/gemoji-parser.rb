# Smoke for gemoji-parser 1.3.1
# gemoji-parser depends on the `gemoji` gem for the Emoji constant.
# The harness gives CRuby -I lib (gemoji-parser's lib) but not gemoji's lib.
# A BEGIN block runs before ANY require_relative in the harness file, so we
# use it to add gemoji's lib to $LOAD_PATH before gemoji-parser.rb's
# `require 'gemoji'` fires.
# The absolute path matches where the gem cache lives on this host.
BEGIN {
  gemoji_lib = "/srv/data/scratch/spinel-compat-cache/gems/gemoji-4.1.0/lib"
  $LOAD_PATH.unshift(gemoji_lib) unless $LOAD_PATH.include?(gemoji_lib)
}

require 'gemoji-parser'

# 1. tokenize: convert unicode emoji to :token: strings
puts EmojiParser.tokenize("Test \u{1f648} \u{1f64a} \u{1f649}")

# 2. detokenize: convert :token: strings back to unicode emoji
puts EmojiParser.detokenize("Test :see_no_evil: :speak_no_evil: :hear_no_evil:")

# 3. parse_tokens with a transformation block
result = EmojiParser.parse_tokens("Hello :tropical_fish:") { |e| "[#{e.name}]" }
puts result

# 4. parse_emoticons with a transformation block
result2 = EmojiParser.parse_emoticons("Hi ;-)") { |e| "[#{e.name}]" }
puts result2

# 5. find an emoji by alias name and report its image path
emoji = EmojiParser.find("smile")
puts emoji.name
puts emoji.image_filename

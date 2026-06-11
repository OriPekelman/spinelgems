# smoke: tts 0.8.2 — pure String methods mixed in via Tts module
# No network, no file I/O, no random, no time

# Tts.server_url returns the default Google TTS URL
puts Tts.server_url

# to_valid_fn replaces forbidden filename chars with underscores
puts "hello/world:test?".to_valid_fn
puts "no_special_chars".to_valid_fn

# split_into_words normalises whitespace then splits
words = "  hello   world  foo  ".split_into_words("  hello   world  foo  ")
puts words.inspect

# validate_text_length: short text returns [text]
short = "hello world"
result = short.validate_text_length(short)
puts result.length
puts result.first

# validate_text_length: long text (>100 chars) gets chunked
long_text = "one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen"
chunks = long_text.validate_text_length(long_text)
puts chunks.length
puts chunks.first

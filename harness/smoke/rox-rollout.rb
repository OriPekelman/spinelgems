require_relative "lib/rox/version"
require_relative "lib/rox/core/roxx/symbols"
require_relative "lib/rox/core/roxx/token_type"
require_relative "lib/rox/core/roxx/string_tokenizer"

puts Rox::VERSION
puts Rox::Core::Symbols::ROXX_TRUE
puts Rox::Core::Symbols::ROXX_FALSE
puts Rox::Core::Symbols::ROXX_UNDEFINED

tt = Rox::Core::TokenType.from_token("true")
puts tt.text

tt2 = Rox::Core::TokenType.from_token("42")
puts tt2.text

tt3 = Rox::Core::TokenType.from_token('"hello"')
puts tt3.text

st = Rox::Core::StringTokenizer.new("hello world foo", " ", false)
tokens = []
tokens << st.next_token while st.more_tokens?
puts tokens.join(",")

# frozen_string_literal: true

require 'awrence'

# 1. Basic snake_case hash → camelBack keys
h = { foo_bar: 1, baz_qux: 2 }
puts h.to_camelback_keys.inspect

# 2. Basic snake_case hash → CamelCase keys
puts h.to_camel_keys.inspect

# 3. String keys
s = { "foo_bar" => "hello", "baz_qux" => "world" }
puts s.to_camelback_keys.inspect
puts s.to_camel_keys.inspect

# 4. Nested hash
nested = { outer_key: { inner_key: 42, another_inner: "val" } }
puts nested.to_camelback_keys.inspect
puts nested.to_camel_keys.inspect

# 5. Array of hashes
arr = [{ snake_case: 1 }, { another_key: 2 }]
puts arr.to_camelback_keys.inspect
puts arr.to_camel_keys.inspect

# 6. Non-string/symbol keys pass through unchanged
mixed = { 123 => "numeric_key", "plain_word" => true }
puts mixed.to_camel_keys.inspect

# 7. Acronym support
Awrence.acronyms = { "api" => "API", "html" => "HTML" }
puts({ api_key: "x", html_content: "y" }.to_camel_keys.inspect)
puts({ api_key: "x", html_content: "y" }.to_camelback_keys.inspect)

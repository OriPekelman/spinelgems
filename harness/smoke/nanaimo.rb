# Smoke: nanaimo - ASCII plist objects using require_relative-loaded classes
# Nanaimo::String, QuotedString, Array, Dictionary are loaded via require_relative in nanaimo.rb

s = Nanaimo::String.new("hello", "a comment")
puts s.value
puts s.annotation
puts s.as_ruby

qs = Nanaimo::QuotedString.new("world", "")
puts qs.value
puts qs.as_ruby

arr = Nanaimo::Array.new([
  Nanaimo::String.new("one", ""),
  Nanaimo::String.new("two", "")
], "")
puts arr.as_ruby.inspect

dict = Nanaimo::Dictionary.new([
  [Nanaimo::String.new("key", ""), Nanaimo::String.new("value", "")]
], "")
puts dict.as_ruby.inspect

s2 = Nanaimo::String.new("hello", "a comment")
puts s == s2

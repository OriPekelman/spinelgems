# smoke: hbl_text - text utilities (encoding conversion + identifier maker)
# Stubs ActiveSupport's present? (Rails dep) so core logic runs without Rails.

class NilClass
  def present?; false; end
  def presence; nil; end
end

class String
  def present?; !empty?; end
  def presence; present? ? self : nil; end
end

class Object
  def present?; !nil? && !(respond_to?(:empty?) && empty?); end
end

require 'hbl_text'

# --- HBLText::Setter.get_charset ---
# Plain ASCII/UTF-8 string -> returns "UTF-8"
charset = HBLText::Setter.get_charset("hello world")
puts "get_charset(ascii): #{charset}"

# Latin-1 encoded string
latin1_str = "caf\xE9".dup.force_encoding("BINARY")
charset2 = HBLText::Setter.get_charset(latin1_str)
puts "get_charset(latin1-like): #{charset2}"

# --- HBLText::Setter.convert_encoding ---
# UTF-8 string stays UTF-8
result = HBLText::Setter.convert_encoding("Hello, World!")
puts "convert_encoding(utf8): #{result}"
puts "convert_encoding encoding: #{result.encoding}"

# Convert an ISO-8859-1 string to UTF-8
iso_str = "caf\xE9".dup.force_encoding("ISO-8859-1")
utf8_result = HBLText::Setter.convert_encoding(iso_str, "ISO-8859-1")
puts "convert_encoding(iso->utf8): #{utf8_result}"
puts "convert_encoding(iso->utf8) encoding: #{utf8_result.encoding}"

# --- HBLText::Setter.to_utf8 on various types ---
# String
s = HBLText::Setter.to_utf8("test string")
puts "to_utf8(string): #{s}"

# Array of strings
arr = HBLText::Setter.to_utf8(["alpha", "beta"])
puts "to_utf8(array): #{arr.inspect}"

# Hash
h = HBLText::Setter.to_utf8({key: "value"})
puts "to_utf8(hash): #{h.inspect}"

# Non-string passthrough
n = HBLText::Setter.to_utf8(42)
puts "to_utf8(integer): #{n}"

# --- String extension ---
puts "String#to_utf8: #{"hello".to_utf8}"

puts "done"

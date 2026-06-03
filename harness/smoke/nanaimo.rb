# frozen_string_literal: true
# Smoke: nanaimo — ASCII plist parse + write roundtrip
require 'nanaimo'

# 1. Parse a simple dictionary plist
dict_plist = "{\n  name = \"Alice\";\n  age = 30;\n  tags = (ruby, plist, ascii);\n}"

plist = Nanaimo::Reader.new(dict_plist).parse!
puts plist.file_type.inspect

ruby_hash = plist.as_ruby
puts ruby_hash['name']
puts ruby_hash['age']
puts ruby_hash['tags'].sort.join(',')

# 2. Check plist_type detection
puts Nanaimo::Reader.plist_type('bplist00...').inspect
puts Nanaimo::Reader.plist_type('<?xml version="1.0"?>').inspect
puts Nanaimo::Reader.plist_type('{ key = val; }').inspect

# 3. Write a Plist back out to string
root = Nanaimo::Dictionary.new(
  {
    Nanaimo::String.new('project', nil) => Nanaimo::QuotedString.new('My App', nil),
    Nanaimo::String.new('version', nil) => Nanaimo::String.new('1.0', nil)
  },
  nil
)
plist2 = Nanaimo::Plist.new(root, :ascii)
output = String.new('')
writer = Nanaimo::Writer.new(plist2, pretty: false, output: output)
writer.write
puts output.include?('project').to_s
puts output.include?('"My App"').to_s
puts output.include?('1.0').to_s

# 4. Array plist round-trip
arr_plist = '(one, two, three)'
arr = Nanaimo::Reader.new(arr_plist).parse!
puts arr.as_ruby.join('-')

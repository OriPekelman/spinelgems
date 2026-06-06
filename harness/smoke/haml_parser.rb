# frozen_string_literal: true
require 'haml_parser'
require 'haml_parser/parser'

# Exercise HamlParser::Parser with real HAML templates

parser = HamlParser::Parser.new

# Test 1: DOCTYPE parsing
haml1 = "!!! 5\n"
ast1 = parser.call(haml1)
doctype_node = ast1.children.first
puts "doctype type: #{doctype_node.to_h[:type]}"
puts "doctype value: #{doctype_node.doctype.inspect}"

# Test 2: Element with class and id
haml2 = "%div.container#main Hello"
ast2 = parser.call(haml2)
elem = ast2.children.first
puts "element type: #{elem.to_h[:type]}"
puts "element tag: #{elem.tag_name}"
puts "element class: #{elem.static_class.inspect}"
puts "element id: #{elem.static_id.inspect}"

# Test 3: Self-closing element
haml3 = "%br/"
ast3 = parser.call(haml3)
br = ast3.children.first
puts "self_closing: #{br.self_closing}"

# Test 4: HTML comment
haml4 = "/ This is a comment"
ast4 = parser.call(haml4)
comment = ast4.children.first
puts "comment type: #{comment.to_h[:type]}"
puts "comment text: #{comment.comment.inspect}"

# Test 5: HAML comment (silent)
haml5 = "-# hidden comment"
ast5 = parser.call(haml5)
hcomment = ast5.children.first
puts "haml_comment type: #{hcomment.to_h[:type]}"

# Test 6: Nested elements and silent script
haml6 = "%ul\n  - items.each do |i|\n    %li= i"
ast6 = parser.call(haml6)
ul = ast6.children.first
puts "nested ul tag: #{ul.tag_name}"
puts "ul children count: #{ul.children.size}"

# Test 7: Filter
haml7 = ":plain\n  raw text here"
ast7 = parser.call(haml7)
filter_node = ast7.children.first
puts "filter type: #{filter_node.to_h[:type]}"
puts "filter name: #{filter_node.name}"
puts "filter texts: #{filter_node.texts.inspect}"

# Test 8: Element attributes
haml8 = "%a{href: '/home'} Home"
ast8 = parser.call(haml8)
link = ast8.children.first
puts "link tag: #{link.tag_name}"
puts "link has old_attrs: #{!link.old_attributes.nil?}"

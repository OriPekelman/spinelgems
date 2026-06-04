# frozen_string_literal: true

require 'front_matter_parser'

# --- Test 1: Markdown-style front matter (empty delimiters) ---
md_doc = <<~MARKDOWN
  ---
  title: Hello World
  published: "2024-01-15"
  tags:
    - ruby
    - spinel
  ---
  This is the body content.
  It has multiple lines.
MARKDOWN

parser = FrontMatterParser::Parser.new(:md)
parsed = parser.call(md_doc)

puts parsed['title']
puts parsed['published']
puts parsed['tags'].join(', ')
puts parsed.content.strip

# --- Test 2: No front matter ---
plain = "Just plain content, no front matter."
parsed2 = parser.call(plain)
puts parsed2.front_matter.empty?.to_s
puts parsed2.content

# --- Test 3: HTML-style front matter ---
html_doc = <<~HTML
  <!--
  ---
  layout: page
  author: Alice
  ---
  -->
  <h1>Hello</h1>
HTML

html_parser = FrontMatterParser::Parser.new(:html)
parsed3 = html_parser.call(html_doc)
puts parsed3['layout']
puts parsed3['author']

# --- Test 4: Single-line comment style (Coffee) ---
# The single-line comment format requires the delimiter on each line of front matter
# and a delimiter-only line as the closing ---
coffee_doc = "# ---\n# title: My Script\n# version: 42\n# ---\nconsole.log 'hello'\n"

coffee_parser = FrontMatterParser::Parser.new(:coffee)
parsed4 = coffee_parser.call(coffee_doc)
puts parsed4['title']
puts parsed4['version']

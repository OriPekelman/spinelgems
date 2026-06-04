# encoding: utf-8
require 'ruby-rtf'

# 1. Utility: twips_to_points
puts RubyRTF.twips_to_points(1440).to_s   # => 72.0 (1 inch = 1440 twips = 72 points)
puts RubyRTF.twips_to_points(20).to_s     # => 1.0

# 2. Parse a minimal RTF document with bold + italic text
rtf_src = '{\\rtf1\\ansi\\deff0' \
          '{\\fonttbl{\\f0\\froman\\fcharset0 Times New Roman;}}' \
          '{\\colortbl ;\\red255\\green0\\blue0;}' \
          '\\f0\\fs24 Hello \\b World\\b0  and \\i italic\\i0 .}'

parser = RubyRTF::Parser.new(unknown_control_warning_enabled: false)
doc = parser.parse(rtf_src)

puts doc.class.name                          # => RubyRTF::Document
puts doc.character_set.inspect               # => :ansi
puts doc.default_font.inspect                # => 0
puts doc.font_table.length.to_s             # => 1 (one font defined)
puts doc.font_table[0].name                 # => "Times New Roman"
puts doc.colour_table.length.to_s          # => 2 (default + red)

# Collect all text from sections
text_parts = doc.sections.map { |s| s[:text] }.reject { |t| t.nil? || t.empty? }
puts text_parts.join('|')                   # shows the text segments

# Check bold section exists
bold_sections = doc.sections.select { |s| s[:modifiers][:bold] }
puts bold_sections.length.to_s             # => > 0

# 3. Parse RTF with paragraph justification + font size
rtf2 = '{\\rtf1\\ansi \\qc\\fs48 Centered\\par\\ql Normal}'
parser2 = RubyRTF::Parser.new(unknown_control_warning_enabled: false)
doc2 = parser2.parse(rtf2)

centered = doc2.sections.select { |s| s[:modifiers][:justification] == :center }
puts centered.length.to_s                  # => at least 1

sized = doc2.sections.select { |s| s[:modifiers][:font_size] }
puts sized.map { |s| s[:modifiers][:font_size] }.first.to_s  # => 24.0

# 4. InvalidDocument is raised for bad input
begin
  RubyRTF::Parser.new.parse("not rtf at all")
  puts "no error"
rescue RubyRTF::InvalidDocument => e
  puts "invalid: #{e.message}"
end

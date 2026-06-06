# frozen_string_literal: true

require 'danger_warnings_next_generation'
require 'warnings_next_generation/markdown_table'

# Exercise WarningsNextGeneration::MarkdownTable - the core self-contained logic

# Test 1: overview_header with to_markdown
overview = WarningsNextGeneration::MarkdownTable.new
overview.overview_header("**Tool**", ":beetle:", ":x:", ":white_check_mark:")
overview.line("SpotBugs", ":star:", 3, 1)
overview.line("CheckStyle", 5, 0, 2)

puts "=== Overview Table ==="
puts overview.to_markdown
puts "size=#{overview.size}"

# Test 2: detail_header with lines
detail = WarningsNextGeneration::MarkdownTable.new
detail.detail_header("**Severity**", "**File**", "**Description**")
detail.line("HIGH", "Foo.java:42", "[NullPointer] Possible NPE")
detail.line("NORMAL", "Bar.rb:7", "[Style] Line too long")
detail.line("LOW", "Baz.kt:99", "Unused variable")

puts ""
puts "=== Detail Table ==="
puts detail.to_markdown
puts "size=#{detail.size}"

# Test 3: empty table (no lines added)
empty = WarningsNextGeneration::MarkdownTable.new
empty.detail_header("**Col1**", "**Col2**")
puts ""
puts "=== Empty Table ==="
puts empty.to_markdown
puts "size=#{empty.size}"

# Test 4: COLUMN_SEPARATOR and HEADER_SEPARATOR constants
puts ""
puts "COLUMN_SEPARATOR=#{WarningsNextGeneration::MarkdownTable::COLUMN_SEPARATOR}"
puts "HEADER_SEPARATOR=#{WarningsNextGeneration::MarkdownTable::HEADER_SEPARATOR}"

# Test 5: VERSION constant
puts "VERSION=#{WarningsNextGeneration::VERSION}"

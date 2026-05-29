require_relative "lib/code_coverage/gem_version"
require_relative "lib/code_coverage/markdown_table"

puts CodeCoverage::VERSION

t = CodeCoverage::MarkdownTable.new
t.header("File", "Coverage")
t.line("foo.rb", "95%")
t.line("bar.rb", "80%")
puts t.size
puts CodeCoverage::MarkdownTable::COLUMN_SEPARATOR
puts CodeCoverage::MarkdownTable::HEADER_SEPARATOR
puts t.to_markdown

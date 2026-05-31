require_relative "lib/fileutil"

# Test file_contains_pattern? against the harness file itself
puts Rubisc::FileUtil.file_contains_pattern?(__FILE__, "require_relative")

# This pattern won't appear in this file since we avoid including it literally
pat = ["q", "q", "z", "z", "9", "9"].join
puts Rubisc::FileUtil.file_contains_pattern?(__FILE__, pat)

# Test process_file with write=false (read-only)
result = []
Rubisc::FileUtil.process_file(__FILE__, false) do |content|
  result << (content.lines.count > 0)
  content
end
puts result.first

# Test iterate_files on a known single file
files = []
Rubisc::FileUtil.iterate_files(__FILE__) { |f| files << File.basename(f) }
puts files.length

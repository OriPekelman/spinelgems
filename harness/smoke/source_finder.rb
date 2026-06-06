require 'source_finder'
require 'source_finder/source_file_globber'

# Exercise SourceFileGlobber without touching the real filesystem.
# Use a null globber that returns empty arrays so glob-dependent methods
# work deterministically.
null_globber = Object.new
def null_globber.glob(_pattern); []; end

g = SourceFinder::SourceFileGlobber.new(globber: null_globber)

# 1. Default source directories (union of all lang dirs, sorted+unique)
puts "source_dirs: #{g.source_dirs_arr.join(',')}"

# 2. Default source file extensions
puts "extensions: #{g.source_file_extensions_arr.join(',')}"

# 3. The combined source+doc extensions
puts "doc_extensions: #{g.source_and_doc_file_extensions_arr.join(',')}"

# 4. The glob string for source files (pattern, not actual files)
glob = g.source_files_glob
# Just print first 80 chars to keep output stable across platforms
puts "source_glob_prefix: #{glob[0, 80]}"

# 5. arr2glob helper
puts "arr2glob_empty: #{g.arr2glob([])}"
puts "arr2glob_items: #{g.arr2glob(['Rakefile', 'Gemfile'])}"

# 6. ruby_files_glob (from RubySourceFileGlobber mixin)
ruby_glob = g.ruby_files_glob
puts "ruby_glob_prefix: #{ruby_glob[0, 60]}"

# 7. exclude_garbage filters emacs lock files
files = ['.#foo.rb', 'lib/bar.rb', '.#baz.rb', 'app/qux.rb']
puts "exclude_garbage: #{g.exclude_garbage(files).join(',')}"

# 8. source_file_extensions_glob is a comma-joined string
puts "extensions_glob_has_rb: #{g.source_file_extensions_glob.include?('rb')}"
puts "doc_glob_has_md: #{g.source_and_doc_file_extensions_glob.include?('md')}"

puts "VERSION: #{SourceFinder::VERSION}"

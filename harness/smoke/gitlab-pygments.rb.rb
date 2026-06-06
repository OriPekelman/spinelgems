# gitlab-pygments.rb smoke
# The gem's main entry point (pygments.rb) pulls in popen.rb which requires
# posix/spawn and yajl — external deps not available in the harness.
# We exercise the pure-Ruby Lexer class directly, which is the self-contained
# part of the gem (reads from a pre-built Marshal lexer database bundled with the gem).

GEM_ROOT = '/home/oripekelman/.cache/spinel-compat/gems/gitlab-pygments.rb-0.5.4'

# Stub the Pygments module with just enough to load pygments/lexer.rb.
# lexer.rb calls Pygments.lexers at the bottom to populate the index.
module Pygments
  def self.lexers
    lexer_file = File.join(GEM_ROOT, 'lexers')
    Marshal.load(File.binread(lexer_file))
  end
end

$LOAD_PATH.unshift(File.join(GEM_ROOT, 'lib'))
require 'pygments/lexer'

# --- find by name (case-insensitive index) ---
ruby = Pygments::Lexer.find('Ruby')
puts "find('Ruby') name: #{ruby.name}"
puts "find('ruby') name: #{Pygments::Lexer.find('ruby').name}"

# --- find_by_name (exact name) ---
python = Pygments::Lexer.find_by_name('Python')
puts "find_by_name('Python') name: #{python.name}"
puts "find_by_name('python') nil: #{Pygments::Lexer.find_by_name('python').nil?}"

# --- find_by_alias ---
rb_lexer = Pygments::Lexer.find_by_alias('rb')
puts "find_by_alias('rb') name: #{rb_lexer.name}"
py_alias = Pygments::Lexer.find_by_alias('python3')
puts "find_by_alias('python3') name: #{py_alias.name}"

# --- find_by_extname ---
rb_ext = Pygments::Lexer.find_by_extname('.rb')
puts "find_by_extname('.rb') name: #{rb_ext.name}"
py_ext = Pygments::Lexer.find_by_extname('.py')
puts "find_by_extname('.py') name: #{py_ext.name}"

# --- find_by_mimetype ---
mime_ruby = Pygments::Lexer.find_by_mimetype('text/x-ruby')
puts "find_by_mimetype('text/x-ruby') name: #{mime_ruby.name}"
mime_python = Pygments::Lexer.find_by_mimetype('text/x-python')
puts "find_by_mimetype('text/x-python') name: #{mime_python.name}"

# --- bracket accessor alias ---
js = Pygments::Lexer['javascript']
puts "Lexer['javascript'] name: #{js.name}"

# --- all returns an array ---
all = Pygments::Lexer.all
puts "all is Array: #{all.is_a?(Array)}"
puts "all.size > 100: #{all.size > 100}"

# --- Struct fields on a lexer ---
puts "ruby aliases include 'rb': #{ruby.aliases.include?('rb')}"
puts "ruby filenames include '*.rb': #{ruby.filenames.include?('*.rb')}"

# --- unknown lookup returns nil ---
puts "find unknown: #{Pygments::Lexer.find('__no_such__').nil?}"
puts "find_by_alias unknown: #{Pygments::Lexer.find_by_alias('__no_such__').nil?}"

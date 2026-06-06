# smoke: rak (rak-eugeneching)
# lib/rak.rb defines only Rak::VERSION = "1.4". All real grep logic lives in
# bin/rak (a CLI-only script using GetoptLong/load-path unavailable in Spinel).
# We inline the pure-Ruby helpers to exercise real logic: tab expansion,
# extension regexp construction, and pattern compilation.

require 'rak'

# --- VERSION from lib/rak.rb ---
puts "version: #{Rak::VERSION}"
puts "class: #{Rak.class}"

# --- Inline String#expand_tabs from bin/rak ---
class String
  def expand_tabs(shift = 0)
    expanded = dup
    1 while expanded.sub!(/\t+/) { " " * ($&.size * 8 - ($`.size + shift) % 8) }
    expanded
  end
end

puts "tab->spaces: #{"\t".expand_tabs.length}"        # tab at col 0 → 8 spaces
puts "a+tab: #{("a\t").expand_tabs.length}"           # 'a' then tab → 8 chars total
puts "notab: #{("hello").expand_tabs}"                # unchanged

# --- Inline FILE_TYPES subset and extension_regexp from bin/rak ---
RUBY_EXTS = %w(.erb .haml .rake .rb .rhtml .rjs .rxml Rakefile Gemfile).freeze

def extension_regexp(extensions)
  return nil if extensions.empty?
  Regexp.compile('(?:' + extensions.map { |x| Regexp.escape(x) }.join("|") + ')\z')
end

re = extension_regexp(RUBY_EXTS)
puts "rb match: #{!!('.rb' =~ re)}"
puts "py match: #{!!('.py' =~ re)}"
puts "Rakefile match: #{!!(('Rakefile') =~ re)}"
puts "empty nil: #{extension_regexp([]).nil?}"

# --- Inline compile_pattern logic from bin/rak ---
def compile_pattern(str, literal: false, match_whole_words: false,
                        match_whole_lines: false, ignore_case: false)
  str = Regexp.quote(str) if literal
  str = "\\b(?:#{str})\\b" if match_whole_words
  str = "^(?:#{str})$" if match_whole_lines
  flags = ignore_case ? Regexp::IGNORECASE : nil
  Regexp.new(str, flags)
end

# regex mode
re_regex = compile_pattern('hel.o')
puts "regex hello: #{!!('hello' =~ re_regex)}"
puts "regex helzo: #{!!('helzo' =~ re_regex)}"
puts "regex world: #{!!('world' =~ re_regex)}"

# literal mode (dot is literal)
re_lit = compile_pattern('hel.o', literal: true)
puts "literal hello: #{!!('hello' =~ re_lit)}"
puts "literal hel.o: #{!!('hel.o' =~ re_lit)}"

# whole word mode
re_word = compile_pattern('cat', match_whole_words: true)
puts "word cat: #{!!('my cat sat' =~ re_word)}"
puts "word cats: #{!!('cats and dogs' =~ re_word)}"

# ignore case mode
re_ci = compile_pattern('hello', ignore_case: true)
puts "icase HELLO: #{!!('HELLO' =~ re_ci)}"
puts "icase world: #{!!('world' =~ re_ci)}"

# whole line mode
re_line = compile_pattern('exact', match_whole_lines: true)
puts "whole line exact: #{!!('exact' =~ re_line)}"
puts "whole line prefix: #{!!('exactly' =~ re_line)}"

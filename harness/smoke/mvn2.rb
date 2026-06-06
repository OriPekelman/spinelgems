require 'mvn2'

# mvn2 is a Maven build wrapper; its main public API is via the VERSION
# constant and the FilterPlugin regex patterns used to parse Maven output.
# The plugin files require 'everyday-plugins' / 'everyday-cli-utils' at
# top-level, so we exercise the parts that are self-contained: the module
# structure and the regex constants defined in FilterPlugin.

puts "VERSION: #{Mvn2::VERSION}"

# Regex and constant definitions from FilterPlugin (inline the regex since
# the plugin files need external deps to load fully under Spinel).
INFO_LINE_FULL = '[INFO] ------------------------------------------------------------------------'
BUILD_REGEX = /(\[(?:\e\S+)?INFO(?:\e\S+)?\] (?:\e\S+)?)Building (?!(jar|war|zip)).*(?:\e\S+)?$/

# Test BUILD_REGEX against Maven output lines
test_lines = [
  '[INFO] Building my-app 1.0.0',
  '[INFO] Building jar',
  '[INFO] Building war',
  '[INFO] Building zip',
  '[INFO] Building another-module 2.3.1',
  '[INFO] Compiling sources',
]

test_lines.each do |line|
  matched = BUILD_REGEX.match(line) ? 'MATCH' : 'NO_MATCH'
  puts "#{matched}: #{line}"
end

# Test the info line separator detection
separator_lines = [
  '[INFO] ------------------------------------------------------------------------',
  '[INFO] Building foo',
  '[ERROR] COMPILATION ERROR :',
  'Results :',
]

separator_lines.each do |line|
  is_sep = line.start_with?('[INFO] ------------------------------------------------------------------------') ? 'SEP' : 'NOT_SEP'
  puts "#{is_sep}: #{line[0..40]}"
end

# Test failure count extraction (from filter logic)
test_result_line = 'Tests run: 5, Failures: 2, Errors: 0, Skipped: 1'
failures = if test_result_line =~ /^.*Failures:\s+(\d+),.*$/
  $1.to_i
else
  -1
end
puts "failures_count: #{failures}"

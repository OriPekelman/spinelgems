require 'un'

# rubysl-un: Unix command emulation utilities via FileUtils wrappers.
# The core public API includes: setup (ARGV parser), and the version constant.
# The FileUtils-calling commands (mkdir/touch/cp/mv/rm) are broken in Ruby 3.4
# because FileUtils removed options-hash support; we test setup() and VERSION.

puts RubySL::Un::VERSION

# setup() parses ARGV options and files; test the option-parsing logic.
def with_argv(*args)
  old = ARGV.dup
  ARGV.replace(args)
  yield
ensure
  ARGV.replace(old)
end

# Plain files, no options
with_argv("src.txt", "dest.txt") do
  setup do |argv, opts|
    puts argv.inspect
    puts opts.inspect
  end
end

# Verbose flag only
with_argv("-v", "file.txt") do
  setup do |argv, opts|
    puts argv.inspect
    puts opts[:verbose].inspect
  end
end

# Options string with option flag
with_argv("-p", "-v", "dir1", "dir2") do
  setup("p") do |argv, opts|
    puts argv.inspect
    puts opts[:p].inspect
    puts opts[:verbose].inspect
  end
end

# Option with value (colon = takes argument)
with_argv("-m", "0755", "outfile") do
  setup("m:") do |argv, opts|
    puts argv.inspect
    puts opts[:m]
  end
end

# Stripping unknown options (e.g. "-x" not in option string keeps only -)
with_argv("-x", "file.txt") do
  setup("p") do |argv, opts|
    # -x is unknown: gets stripped to "-", which setup then removes
    puts argv.inspect
    puts opts.empty?.inspect
  end
end

puts "done"

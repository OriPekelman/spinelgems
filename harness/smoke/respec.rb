require 'respec'

# Exercise Respec::VERSION (Array with custom to_s and Comparable)
v = Respec::VERSION
puts "version: #{v}"
puts "version string: #{v.to_s}"
puts "version >= 1.0.0: #{(v <=> [1, 0, 0]) >= 0}"

# Exercise Respec::App argument parsing logic.
# App#initialize parses args; App#help returns the usage string.
# We use a non-existent failures path so no filesystem state is needed.
Respec::App.default_failures_path = '/tmp/respec_smoke_failures_nonexistent'

# --help / help arg
app_help = Respec::App.new('help')
puts "help_only: #{app_help.help_only?}"
puts "help includes USAGE: #{app_help.help.include?('USAGE')}"

# Plain rspec option pass-through: -t mytag
app_tag = Respec::App.new('-t', 'mytag')
puts "tag args include -t: #{app_tag.generated_args.include?('-t')}"
puts "tag args include mytag: #{app_tag.generated_args.include?('mytag')}"

# Pattern match: a bare word becomes -e <word>
app_pat = Respec::App.new('myexample')
puts "pattern -e present: #{app_pat.generated_args.include?('-e')}"
puts "pattern value present: #{app_pat.generated_args.include?('myexample')}"

# Separator '--' splits respec-args from rspec-args
app_sep = Respec::App.new('--', '--color')
puts "raw args: #{app_sep.raw_args.inspect}"

# FAILURES= override
app_fail = Respec::App.new('FAILURES=/tmp/custom_path')
puts "failures_path overridden: #{app_fail.failures_path == '/tmp/custom_path'}"

# formatter_args returns an array containing the formatter path
app_fmt = Respec::App.new
fargs = app_fmt.formatter_args
puts "formatter_args non-empty: #{fargs.length > 0}"
puts "formatter_args ends with formatter.rb: #{fargs.last.end_with?('formatter.rb')}"

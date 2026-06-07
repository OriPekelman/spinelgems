require 'libclimate'

# Exercise LibCLImate::Climate: add_flag, add_option, parse + verify,
# block callbacks, flag_is_specified, and the run() method.
# No network, no file writes; all transitive deps (clasp, xqsr3) are
# in the gem cache and compiled together by Spinel.

# --- Test 1: parse + verify with flag and option ---
verbose = false
flavour = nil

cl = LibCLImate::Climate.new(no_help_flag: true, no_version_flag: true) do |c|
  c.add_flag('--verbose', alias: '-v', help: 'Verbose output') { verbose = true }
  c.add_option('--flavour', alias: '-f', help: 'Flavour') { |o, _| flavour = o.value }
  c.program_name = 'test-prog'
  c.exit_on_missing = false
  c.exit_on_unknown = false
end

r = cl.parse(['--verbose', '--flavour=sweet', 'arg1', 'arg2'])
r.verify

puts "flags count: #{r.flags.size}"
puts "options count: #{r.options.size}"
puts "values count: #{r.values.size}"
puts "verbose: #{verbose}"
puts "flavour: #{flavour}"
puts "values: #{r.values.join(', ')}"
puts "program_name: #{cl.program_name}"
puts "specs count: #{cl.specifications.size}"

# --- Test 2: run() with short alias ---
mode = 'default'

cl2 = LibCLImate::Climate.new(no_help_flag: true, no_version_flag: true) do |c|
  c.add_option('--mode', alias: '-m') { |o, _| mode = o.value }
  c.exit_on_unknown = false
  c.exit_on_missing = false
end

r2 = cl2.run(['-m=fast', 'fileA'])
puts "mode via alias: #{mode}"
puts "run values: #{r2.values.join(', ')}"

# --- Test 3: flag_is_specified ---
debug = false

cl3 = LibCLImate::Climate.new(no_help_flag: true, no_version_flag: true) do |c|
  c.add_flag('--debug') { debug = true }
  c.exit_on_unknown = false
end

r3 = cl3.parse(['--debug'])
r3.verify
puts "flag_is_specified: #{r3.flag_is_specified('--debug')}"
puts "debug triggered: #{debug}"

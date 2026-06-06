require 'clasp-ruby'

# Smoke: exercises CLASP.Flag, CLASP.Option, CLASP.parse with concrete argv

# 1. FlagSpecification: name, aliases, help, to_s
fs = CLASP.Flag('--verbose', alias: '-v', help: 'enable verbose output')
puts fs.name
puts fs.aliases.inspect
puts fs.help
puts fs == '--verbose'
puts fs == '-v'

# 2. OptionSpecification: name, default_value, required?, to_s fragment
os = CLASP.Option('--output', alias: '-o', help: 'output file', default_value: 'out.txt')
puts os.name
puts os.aliases.inspect
puts os.default_value
puts os.required?

# 3. Parse a concrete argv with flags, options, and a value
argv  = ['--verbose', '--output=result.txt', 'input.rb']
specs = [fs, os]
args  = CLASP.parse(argv, specs)

puts args.flags.size
puts args.flags.first.name
puts args.options.size
puts args.options.first.name
puts args.options.first.value
puts args.values.size
puts args.values.first

# 4. find_flag / find_option
puts args.find_flag('--verbose').nil?.inspect
puts args.find_option('--output').value

# 5. FlagSpecification equality against String
puts CLASP::FlagSpecification.Help.name
puts CLASP::FlagSpecification.Version.name
